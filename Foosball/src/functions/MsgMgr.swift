//
//  MsgMgr.swift
//  Foosball
//
//  Created by luleyan on 2017/1/23.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class MsgContainer {
    // 每个event对应其对话列表和这个对话是否已经被下载
    fileprivate(set) var msgIdList: [DataID.IDType] = []
    fileprivate(set) var msgDict: [DataID.IDType: MsgStruct] = [:]
    fileprivate(set) var insertPos: [Int] = []

    // 已经保持的msg的数量
    fileprivate(set) var msgNum: Int = 20
}

typealias MsgContainerList = [DataID.IDType: MsgContainer]

protocol MsgMgrObserver {
    func getCurEventID() -> DataID
    func onModify(msgs: MsgContainerList)
}

class MsgMgr: DataMgr<MsgContainerList, MsgMgrObserver>, ActiveEventsMgrObserver {

    static var attrisKeeper: [String: Any] = [
        "id": "id",
        "u": "userid",
        "tm": "Date",
        "msg": "str"
    ]

    var curEventID: DataID? = nil

    override init() {
        super.init()
        print("初始化 MsgMgr")


        data = [:]
    }

    // set ob --------------------------------------------------
    let DataObKey = "DataMgr"

    override func unregister(key: String) {
        super.unregister(key: key)
        if obDict.count == 0 {
            APP.activeEventsMgr.unregister(key: DataObKey)
        }
    }

    override func initObserver(_ ob: MsgMgrObserver) {
        curEventID = ob.getCurEventID()

        // 注册成为 act events的观察者，当其有变化时，检测是否是当前event的msg的变化
        APP.activeEventsMgr.register(observer: self, key: DataObKey)

    }

    // 从act events获取对应事件的msg id 与数据表中比较，前20个里面没有下载的则开启下载
    override func modifyObserver(_ ob: MsgMgrObserver) {
        ob.onModify(msgs: data)
    }

    // ---------------------------------------------------------

    func onInit(actE: ActEvents) {
        if let e = actE.getCurEvent(curId: curEventID!) {
            handleMsgIds(e.msgIDList)
        }
    }

    func onModify(actE: ActEvents) {
        if let e = actE.getCurEvent(curId: curEventID!) {
            handleMsgIds(e.msgIDList)
        }
    }

    func handleMsgIds(_ ids: [DataID.IDType]) {
        var msgContainer = data[curEventID!.ID]
        var downIDList: [DataID.IDType] = []
        var insertPos: [Int] = []

        if msgContainer == nil {
            msgContainer = MsgContainer()

            let numFrom = max(ids.count - msgContainer!.msgNum, 0)
            for i in numFrom ..< ids.count {
                let id = ids[i]
                downIDList.append(id)
            }

            data[curEventID!.ID] = msgContainer
        } else {
            // 对比
            let checkOriNumMax = min(ids.count, msgContainer!.msgNum)
            let checkSaveNumMin = msgContainer!.msgIdList.count - 1 - 4
            var i = 0
            var k = msgContainer!.msgIdList.count - 1
            while true {
                if k <= checkSaveNumMin { // 有n个匹配上，说明不会再找到新增了
                    break
                }

                if i >= checkOriNumMax { // 所有最前面的几个都是新的
                    break
                }

                let id = ids[ids.count - 1 - i]
                if msgContainer!.msgIdList[k] != id {
                    downIDList.append(id)
                    insertPos.append(i)
                    i += 1
                } else {
                    k -= 1
                    i += 1// 对比下一个记录值
                }
            }
        }

        if downIDList.count > 0 {
            downloadMsgs(downIDList, insertPos, container: msgContainer!)
        }
    }

    func downloadMsgs(_ downIDList: [DataID.IDType], _ insertList: [Int], container: MsgContainer) {
        Network.shareInstance.updateObjs(from: MsgStruct.classname, ids: downIDList, with: []) { suc, objs in
            if !suc {
                print("ERROR: downloadMsgs wrong")
                APP.errorMgr.hasError()
                return
            }

            DispatchQueue(label: self.parseThreadName).async {
                var msgList: [MsgStruct] = []
                var needFetchUserList: [User] = []
                Network.shareInstance.parse(obj: objs!, by: &MsgMgr.attrisKeeper, callback: { str, attris in
                    if str == "" {
                        let msg = self.createMsgStruct(attris, needFetchUsers: &needFetchUserList)
                        msgList.append(msg)
                    }
                })

                DispatchQueue.main.async {
                    self.resetMsg(in: container, msgs: msgList)
                    self.updateData(downIDList, insertList, container: container)

                    if needFetchUserList.count > 0 {
                        APP.userMgr.fetchUnfetchUsers(needFetchUserList) { suc in
                            if suc {
                                self.updateObserver()
                                self.saveData()
                            } else {
                                APP.errorMgr.hasError()
                            }
                        }
                    } else {
                        self.updateObserver()
                        self.saveData()
                    }
                }
            }
        }
    }

    // 创建msg的结构体，根据服务器获得的属性，如果用户未获取，则记录
    func createMsgStruct(_ attris: [String: Any], needFetchUsers: inout [User]) -> MsgStruct {
        let ms = MsgStruct(ID: DataID(ID: attris["id"] as! DataID.IDType))
        ms.msg = attris["msg"] as! String
        ms.time = Time(t: attris["tm"] as? Date)

        let (user, needFetch) = APP.userMgr.getOrCreateUser(id: attris["u"] as! DataID.IDType)
        ms.user = user

        if needFetch {
            needFetchUsers.append(user)
        }

        return ms
    }

    // 下载好的msg放到一个字典里，以后根据list中的id获取
    func resetMsg(in c: MsgContainer, msgs: [MsgStruct]) {
        var dict = c.msgDict
        for msg in msgs {
            dict[msg.ID.ID] = msg
        }
    }

    // 完成下载，更新data中的msgList，这样就可以获取了
    func updateData(_ downIDList: [DataID.IDType], _ insertList: [Int], container: MsgContainer) {
        if container.msgIdList.count == 0 {
            container.msgIdList = downIDList
            container.insertPos = []
            container.msgNum = downIDList.count
        } else {
            for i in 0 ..< downIDList.count {
                container.msgIdList.insert(downIDList[i], at: container.msgIdList.count - insertList[i])
            }
            container.insertPos = insertList
            container.msgNum += downIDList.count
        }
    }
}
