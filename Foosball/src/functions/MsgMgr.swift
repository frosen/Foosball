//
//  MsgMgr.swift
//  Foosball
//
//  Created by luleyan on 2017/1/23.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class MsgContainer {
    fileprivate(set) var msgList: [MsgStruct] = [] // 按照时间从最新到最以前排列，和event中相反

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

        mc.msgList = [
            MsgStruct(id: DataID(ID: "m1"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么1"),
            MsgStruct(id: DataID(ID: "m2"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n21你说什么\n21你说什么\n21你说什么\n21你说什么"),
            MsgStruct(id: DataID(ID: "m3"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么3"),
            MsgStruct(id: DataID(ID: "m4"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n4\n21你说什么\n21你说什么"),
            MsgStruct(id: DataID(ID: "m5"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么5"),
            MsgStruct(id: DataID(ID: "m6"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n6\n21你说什么\n21你说什么\n21你说什么"),
            MsgStruct(id: DataID(ID: "m7"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么7"),
            MsgStruct(id: DataID(ID: "m8"), user: APP.userMgr.me, time: Time.now, msg: "1你说什么\n8\n21你说什么\n21你说什么\n21你说什么\n21你说什么\n21你说什么\n21你说什么"),
        ]

        data[DataID(ID: "50001")] = mc
    }

    // set ob --------------------------------------------------

    let DataObKey = "MsgMgr"

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
        if let msgContainer = data[curEventID ?? DataID(ID: "")] {
            ob.onModify(msgs: msgContainer)
        }
    }

    // ---------------------------------------------------------

    func onInit(actE: ActEvents) {
        if let msgContainer = data[curEventID!] {
            if msgContainer.msgList.count > 0 {
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

        if msgContainer == nil {
            msgContainer = MsgContainer()

            let numFrom = max(ids.count - msgContainer!.msgNeedNum, 0)
            for i in (numFrom ..< ids.count).reversed() {
                let id = ids[i]
                downIDList.append(id)
            }

            data[curEventID!] = msgContainer
        } else {
            // 对比
            let checkOriginNumMax = min(ids.count, msgContainer!.msgNeedNum)
            let savedLastMsgId = msgContainer!.msgList.first?.ID.rawValue
            for originIndex in 0 ..< checkOriginNumMax {
                let originId = ids[ids.count - 1 - originIndex] // 倒着找
                if savedLastMsgId != originId {
                    downIDList.append(originId)
                } else {
                    break
                }
            }
        }

        if downIDList.count > 0 {
            downloadMsgs(downIDList, container: msgContainer!)
        }
    }

    private func downloadMsgs(_ downIDList: [DataID.IDType], container: MsgContainer) {
        Network.shareInstance.fetchObjs(from: MsgStruct.classname, ids: downIDList, with: [], orderType: 2) { suc, objs in
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
                    self.updateData(msgList, container: container)

                    if needFetchUserList.count > 0 {
                        APP.userMgr.fetchUnfetchUsers(needFetchUserList) { suc in
                            if suc {
                                self.updateObserver()
                                self.saveToLocal()
                            } else {
                                APP.errorMgr.hasError()
                            }
                        }
                    } else {
                        self.updateObserver()
                        self.saveToLocal()
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

    // 完成下载，更新data中的msgList，这样就可以获取了
    func updateData(_ downMsgList: [MsgStruct], container: MsgContainer) {
        if container.msgList.count == 0 {
            container.msgList = downMsgList
        } else {
            container.msgList = downMsgList + container.msgList
        }
    }

    // 上传 -------------------------------------------------------------------------------

    func addNewMsg(_ newMsg: MsgStruct, obKey: String, callback: @escaping ((Bool) -> Void)) {
        let attris: [String: Any] = [
            "u": newMsg.user!.ID.rawValue,
            "tm": newMsg.time!.getTimeData(),
            "msg": newMsg.msg,
        ]

        Network.shareInstance.createObj(to: MsgStruct.classname, attris: attris) { suc, error, newID in
            print("create Msg on net: \(suc), ", error ?? "no error")
            if suc {
                // 更新event
                self.addNewMsgToEvent(newID!, eventId: self.curEventID!) { suc in
                    if suc {
                        APP.userMgr.fetchMeAtOnce()
                    }
                    if self.hasOb(for: obKey) {
                        callback(suc)
                    }
                }
            } else {
                if self.hasOb(for: obKey) {
                    callback(false)
                }
            }
        }
    }

    private func addNewMsgToEvent(_ msgId: String, eventId: DataID, callback: @escaping ((Bool) -> Void)) {
        Network.shareInstance.addData(to: Event.classname, id: eventId.rawValue, attris: [
            "msg": msgId
        ]) { suc, error in
            print("addNewMsgToEvent: \(suc), ", error ?? "no error")
            callback(suc)
        }
    }

    // 临时信息记录 ======================================================

    class MsgStructList: NSObject { // 使用一个类套在list之上，为了在复制时只复制其引用，而不是数据
        var list: [MsgStruct] = []
    }

    var tmpMsgListDict: [DataID: MsgStructList] = [:]
}









