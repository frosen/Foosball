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

    // 需要保持的msg的数量
    fileprivate(set) var msgNeedNum: Int = 20
}

protocol MsgMgrObserver {
    func getCurEventID(for msgMgr: MsgMgr) -> DataID
    func onModify(msgs: MsgContainer)
}

class MsgMgr: DataMgr<[DataID: MsgContainer], MsgMgrObserver>, ActiveEventsMgrObserver {

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

        test()
    }

    func test() {
        print("test")
        // 测试代码
        let mc = MsgContainer()
        mc.msgIdList = [
            "m1", "m2", "m3", "m4", "m5", "m6", "m7", "m8"
        ]
        mc.msgDict = [
            "m1": MsgStruct(id: DataID(ID: "m1"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么1"),
            "m2": MsgStruct(id: DataID(ID: "m2"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n2"),
            "m3": MsgStruct(id: DataID(ID: "m3"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么3"),
            "m4": MsgStruct(id: DataID(ID: "m4"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n4"),
            "m5": MsgStruct(id: DataID(ID: "m5"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么5"),
            "m6": MsgStruct(id: DataID(ID: "m6"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n6"),
            "m7": MsgStruct(id: DataID(ID: "m7"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么7"),
            "m8": MsgStruct(id: DataID(ID: "m7"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n8"),
        ]

        data[DataID(ID: "50001")] = mc
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
        curEventID = ob.getCurEventID(for: self)

        // 注册成为 act events的观察者，当其有变化时，检测是否是当前event的msg的变化
        APP.activeEventsMgr.register(observer: self, key: DataObKey)

    }

    // 从act events获取对应事件的msg id 与数据表中比较，前20个里面没有下载的则开启下载
    override func modifyObserver(_ ob: MsgMgrObserver) {
        if let msgContainer =  data[curEventID ?? DataID(ID: "")] {
            ob.onModify(msgs: msgContainer)
        }
    }

    // ---------------------------------------------------------

    func onInit(actE: ActEvents) {
        if let msgContainer = data[curEventID!] {
            if msgContainer.msgIdList.count > 0 {
                updateObserver()
            }
        }

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
        var msgContainer = data[curEventID!]
        var downIDList: [DataID.IDType] = []
        var insertPos: [Int] = []

        if msgContainer == nil {
            msgContainer = MsgContainer()

            let numFrom = max(ids.count - msgContainer!.msgNeedNum, 0)
            for i in numFrom ..< ids.count {
                let id = ids[i]
                downIDList.append(id)
            }

            data[curEventID!] = msgContainer
        } else {
            // 对比
            let checkOriginNumMax = min(ids.count, msgContainer!.msgNeedNum)
            let checkSaveNumMin = msgContainer!.msgIdList.count - 1 - 4
            var originIndex = 0
            var saveIndex = msgContainer!.msgIdList.count - 1
            while true {
                if saveIndex <= checkSaveNumMin { // 有n个匹配上，说明不会再找到新增了
                    break
                }

                if originIndex >= checkOriginNumMax { // 所有最前面的几个都是新的
                    break
                }

                let originId = ids[ids.count - 1 - originIndex] // 倒着找
                if msgContainer!.msgIdList[saveIndex] != originId {
                    downIDList.append(originId)
                    insertPos.append(originIndex)
                    originIndex += 1
                } else {
                    saveIndex -= 1
                    originIndex += 1// 对比下一个记录值
                }
            }
        }

        if downIDList.count > 0 {
            downloadMsgs(downIDList, insertPos, container: msgContainer!)
        }
    }

    private func downloadMsgs(_ downIDList: [DataID.IDType], _ insertList: [Int], container: MsgContainer) {
        Network.shareInstance.updateObjs(from: MsgStruct.classname, ids: downIDList, with: []) { suc, objs in
            if !suc {
                print("ERROR: downloadMsgs wrong")
                APP.errorMgr.hasError()
                return
            }

            DispatchQueue(label: self.parseThreadName).async {
                var msgList: [MsgStruct] = []
                Network.shareInstance.parse(obj: objs!, by: &MsgMgr.attrisKeeper, callback: { str, attris in
                    if str == "" {
                        let msg = MsgMgr.createMsgStruct(attris)
                        msgList.append(msg)
                    }
                })

                // 检测需要获取的user
                var needFetchUserList: [User] = []
                let oldUsers = APP.userMgr.data!
                for ms in msgList {
                    var isNew = true
                    for oldUser in oldUsers {
                        if ms.user!.ID == oldUser.ID {
                            ms.user = oldUser
                            isNew = false
                            break
                        }
                    }
                    if isNew {
                        needFetchUserList.append(ms.user!)
                    }
                }

                DispatchQueue.main.async {
                    self.saveMsg(in: container, msgs: msgList)
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
    class func createMsgStruct(_ attris: [String: Any]) -> MsgStruct {
        let ms = MsgStruct(ID: DataID(ID: attris["id"] as! DataID.IDType))
        ms.msg = attris["msg"] as! String
        ms.time = Time(t: attris["tm"] as? Date)
        ms.user = User(ID: DataID(ID: attris["id"] as! DataID.IDType)) // 先暂时都是用新建的user

        return ms
    }

    // 下载好的msg放到一个字典里，以后根据list中的id获取
    func saveMsg(in c: MsgContainer, msgs: [MsgStruct]) {
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
        } else {
            for i in 0 ..< downIDList.count {
                container.msgIdList.insert(downIDList[i], at: container.msgIdList.count - insertList[i])
            }
            container.insertPos = insertList
        }
    }

    // 上传 -------------------------------------------------------------------------------

    func addNewMsg(_ newMsg: MsgStruct) {
        guard let msgContainer = data[curEventID!] else {
            return
        }

        msgContainer.msgIdList.append(newMsg.ID.rawValue)
        msgContainer.msgDict[newMsg.ID.rawValue] = newMsg
        msgContainer.insertPos = [0]
        updateObserver()

//        let attris: [String: Any] = [
//            "u": newMsg.user!.ID.rawValue,
//            "tm": newMsg.time!.getTimeData(),
//            "msg": newMsg.msg,
//        ]
//
//        Network.shareInstance.createObj(to: MsgStruct.classname, attris: attris) { suc, error, newID in
//            print("create Msg on net: \(suc), ", error ?? "no error")
//            if suc {
//                newMsg.ID = DataID(ID: newID!)
//                self.data.eList.append(e)
//                APP.userMgr.addNewEvent(e) { suc, error in
//                    if suc {
//                        self.updateObserver()
//                        self.saveData()
//                    }
//                    callback(suc, error)
//                }
//            } else {
//                callback(suc, error)
//            }
//        }
    }
}
