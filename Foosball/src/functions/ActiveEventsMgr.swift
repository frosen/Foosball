//
//  ActiveEventsMgr.swift
//  Foosball
//  活动事件管理器
//  某个view可以在此注册一个function，当data有变化时，运行每个注册的function，如果是有变化的，则变化相应的view
//  Created by luleyan on 2016/10/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ActEvents {
    fileprivate(set) var eList: [Event] = []

    func getCurEvent(curId: DataID) -> Event? {
        for i in 0 ..< eList.count {
            if curId == eList[i].ID {
                return eList[i]
            }
        }
        return nil
    }
}

protocol ActiveEventsMgrObserver {
    func onInit(actE: ActEvents)
    func onModify(actE: ActEvents)
}


class ActiveEventsMgr: DataMgr<ActEvents, ActiveEventsMgrObserver> {

    static var attrisKeeper: [String: Any] = [
        "id": "id",
        "tp": 1,
        "i": 1,
        "mc1": 1,
        "mc2": 1,
        "ivt": false,
        "tm": "Date",
        "loc": "Location",
        "p2m": false,
        "wg": ["wg"],
        "dtl": "detail",
        "our": [["k": "v"]],
        "opp": [["k": "v"]],
        "img": ["url"],
        "msg": ["id"],
        "ctm": "Date",
        "cid": "id"
    ]

    override init() {
        super.init()
        print("初始化 ActiveEventsMgr")

        // 初始化数据结构
        data = ActEvents()

        // 读取本地数据
        loadFromLocal()
        loadEventsChangeFromLocal()

        test()
    }

    func test() {
        //自己方
        let bb1 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        let p1 = UserState(user: bb1, state: .invite)

        let bb2 = User(ID: DataID(ID: "123"), name: "佐助", url: "")
        bb2.name = "小明2"
        let p2 = UserState(user: bb2, state: .ongoing)

        let bb3 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb3.name = "小明3"
        let p3 = UserState(user: bb3, state: .waiting)

        let bb12 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb12.name = "明a"
        let p12 = UserState(user: bb12, state: .win)

        let bb22 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb22.name = "明b"
        let p22 = UserState(user: bb22, state: .lose)

        let bb32 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb32.name = "明3"
        let p32 = UserState(user: bb32, state: .finish)

        let bb321 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb321.name = "明4"
        let p321 = UserState(user: bb321, state: .finish)



        // 对方
        let bk1 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bk1.name = "小王a"
        let pk1 = UserState(user: bk1, state: .invite)

        let bk2 = User(ID: DataID(ID: "123"), name: "佐助", url: "")
        bk2.name = "小王b"
        let pk2 = UserState(user: bk2, state: .invite)

        let bk3 = User(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bk3.name = "大王c"
        let pk3 = UserState(user: bk3, state: .invite)

        var e: Event! = nil

        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)
        //
        //        e = Event(ID: DataID(ID: "123"))
        //        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        //        e.opponentStateList = [pk1, pk2, pk3]
        //        data.add(e: e)

        // -----------------
        e = Event(ID: DataID(ID: "50001"))

        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]

        e.imageURLList = ["http://up.qqjia.com/z/25/tu32700_3.png", "http://up.qqjia.com/z/25/tu32718_6.png", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg"]
        
        e.detail = "~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；"
        
        e.wagerList = [Wager(str: "红牛")]
        
        
        
        e.createTime = Time.now
        e.createUserID = DataID(ID: "123")
        
        e.location = Location()
        
        e.time = Time(timeIntervalSinceNow: 136000)

        e.msgIDList = ["m8", "m7", "m6", "m5", "m4", "m3", "m2", "m1", "589459362f301e00690096db", "589456b8128fe1006ca1ca29", "58944f400ce4630056f1a996"]
        
        data.eList.append(e)
    }

    // set ob --------------------------------------------------------------

    override func initObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onInit(actE: data)
    }

    override func modifyObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onModify(actE: data)
    }

    // 刷新数据时调用 ---------------------------------------------------------

    class func createNewEvent(_ attris: [String: Any]) -> Event {
        let e = Event(ID: DataID(ID: attris["id"] as! DataID.IDType))
        setAttris(attris, e: e)
        return e
    }

    class private func setAttris(_ attris: [String: Any], e: Event) {
        e.type = EventType(rawValue: attris["tp"] as! Int)!
        e.item = ItemType.list[attris["i"] as! Int]
        e.memberCount = attris["mc1"] as! Int
        e.memberCount2 = attris["mc2"] as! Int
        e.time = Time(t: attris["tm"] as? Date)
        e.location.set(loc: attris["loc"] as! CLLocation)
        e.isPublishToMap = attris["p2m"] as! Bool
        e.wagerList = DataTools.Wagers.unserialize(attris["wg"] as! [String])
        e.detail = attris["dtl"] as! String

        e.ourSideStateList = DataTools.UserStates.unserialize(attris["our"] as! [[String: Any]])
        e.opponentStateList = DataTools.UserStates.unserialize(attris["opp"] as! [[String: Any]])

        e.imageURLList = attris["img"] as! [String]
        e.msgIDList = attris["msg"] as! [String]

        e.createTime = Time(t: attris["ctm"] as? Date)
        e.createUserID = DataID(ID: attris["cid"] as! DataID.IDType)
    }

    func updateData(_ newEList: [Event]) {
        // todo 以后要改成根据new list进行新增，按顺序添加到data上，并remove以前同id的
        data.eList = newEList
    }

    // 检查变化 ------------------------------------------------------------

    // 记录每个事件更新时，状态和对话数的变化
    class EventChange: NSObject {
        fileprivate(set) var curState: EventState
        fileprivate(set) var isStateChange: Bool

        fileprivate(set) var curMsgNum: Int
        fileprivate(set) var oldMsgNum: Int

        fileprivate init(curState: EventState, stateChange: Bool, curMsgN: Int, oldMsgN: Int) {
            self.curState = curState
            self.isStateChange = stateChange

            self.curMsgNum = curMsgN
            self.oldMsgNum = oldMsgN

            super.init()
        }

        func getMsgNumChange() -> Int {
            return curMsgNum - oldMsgNum
        }
    }
    
    private(set) var eventChangeMap: [DataID: EventChange]? = nil

    class func checkNewEventChangeMap(newEvents: [Event], oldChangeMap: [DataID: EventChange]?) -> [DataID: EventChange] {
        var newChangeMap: [DataID: EventChange] = [:]

        if oldChangeMap == nil {
            for new in newEvents {
                let newState = UserMgr.getState(from: new, by: APP.userMgr.me.ID)
                let msgNum = new.msgIDList.count
                newChangeMap[new.ID] = EventChange(curState: newState, stateChange: false, curMsgN: msgNum, oldMsgN: msgNum)
            }
        } else {
            // 新的events中所有旧events没有，或者有但是状态不一致和对话数量不一致的记录下来
            for new in newEvents {
                let newState = UserMgr.getState(from: new, by: APP.userMgr.me.ID)
                let msgNum = new.msgIDList.count

                if newState == .finish || newState == .keepImpeach_win || newState == .keepImpeach_lose {
                    newChangeMap[new.ID] = EventChange(curState: newState, stateChange: false, curMsgN: msgNum, oldMsgN: msgNum)
                    continue
                }

                let oldChange = oldChangeMap![new.ID]
                if oldChange == nil {
                    newChangeMap[new.ID] = EventChange(curState: newState, stateChange: true, curMsgN: msgNum, oldMsgN: 0)
                } else {
                    let stateChange = (oldChange!.curState != newState)
                    newChangeMap[new.ID] = EventChange(curState: newState, stateChange: stateChange, curMsgN: msgNum, oldMsgN: oldChange!.oldMsgNum)
                }
            }
        }

        return newChangeMap
    }

    func saveChange(_ newChangeMap: [DataID: EventChange]) {
        if eventChangeMap == nil {
            return
        }

        for change in newChangeMap {
            eventChangeMap![change.key] = change.value
        }

        saveEventsChangeToLocal()
    }

    func clearEventChange(_ id: DataID) {
        if let oldChange = eventChangeMap?[id] {
            oldChange.isStateChange = true
            oldChange.oldMsgNum = oldChange.curMsgNum
        }
        saveEventsChangeToLocal()
    }

    private func saveEventsChangeToLocal() {

    }

    private func loadEventsChangeFromLocal() {

    }

    // 本地便捷函数 ------------------------------------------------------------

    func addNewEvent(_ e: Event, callback: @escaping ((Bool) -> Void)) {
        let attris: [String: Any] = [
            "tp": e.type.rawValue,
            "i": e.item.tag,
            "mc1": e.memberCount,
            "mc2": e.memberCount2,
            "ivt": e.canInvite,
            "tm": e.time.getTimeData(),
            "loc": e.location.loc,
            "p2m": e.isPublishToMap,
            "wg": DataTools.Wagers.serialize(e.wagerList),
            "dtl": e.detail,
            "our": DataTools.UserStates.serialize(e.ourSideStateList),
            "opp": DataTools.UserStates.serialize(e.opponentStateList),
            "img": e.imageURLList,
            "msg": [], // 新事件并没有对话
            "ctm": e.createTime.getTimeData(),
            "cid": e.createUserID.rawValue
        ]

        Network.shareInstance.createObj(to: Event.classname, attris: attris) { suc, error, newID in
            print("create event on net: \(suc), ", error ?? "no error")
            if suc {
                e.ID = DataID(ID: newID!)
                ActiveEventsMgr.addNewEventToUser(e) { suc in
                    if suc {
                        APP.userMgr.fetchMeAtOnce()
                    }
                    callback(suc)
                }
            } else {
                callback(suc)
            }
        }
    }

    // 同时给活动事件和所有事件
    private class func addNewEventToUser(_ e: Event, callback: @escaping ((Bool) -> Void)) {
        Network.shareInstance.addDataToUser([
            "active": e,
            "events": e.ID.rawValue
        ]) { suc, error in
            print("addNewEvent to User", suc, error ?? "no_error")
            callback(suc)
        }
    }

    // --------------------------------------------------------------------------------

    func updateEvent(_ e: Event, attris: [String: Any], callback: @escaping ((Bool) -> Void)) {
        Network.shareInstance.updateObj(from: Event.classname, id: e.ID.rawValue, attris: attris) { suc, error in
            print("updateEvent event on net: \(suc), ", error ?? "no error")
            if suc {
                self.saveToLocal()
            }
            callback(suc)
        }
    }

    // 添加一张图片到某个event上，回调前会判断obKey是否存在，不存在就不执行了，callback参数 回调类型，进度
    func addNewImg(_ img: UIImage, eventId: DataID, obKey: String, callback: @escaping ((String, Int) -> Void)) {
        guard let imgData = UIImageJPEGRepresentation(img, 0.5) else { // 使用jpg减少图片尺寸
            print("ERROR: can not change to JPEG")
            callback("fail", 0)
            return
        }

        guard let event = data.getCurEvent(curId: eventId) else {
            print("ERROR: no event in addNewImg")
            return
        }

        let filename = APP.userMgr.data[0].name + "_" + Time.now.toWholeString + ".jpg"

        Network.shareInstance.upload(data: imgData, name: filename) { str, progress in
            if str != "p" && str != "fail" {
                self.changeData(changeFunc: { _ in
                    event.imageURLList.append(str)
                    return nil
                }, needUpload: ["img": "add"])
            }

            if self.hasOb(for: obKey) {
                callback(str, progress)
            }
        }
    }

    // 获取裁切后图片的url
    func getImgUrl(from str: String, useCut: Bool = false) -> String {

        return str // todo

//        if useCut == false {
//            return str
//        }
//
//        let cutUrl: String = Network.shareInstance.getCutImgUrl(from: str, by: 72) ?? str
//        return cutUrl
    }

    func addNewMsg(_ msgId: DataID.IDType, to eventId: DataID, callback: @escaping ((Bool) -> Void)) {
        let e = data.getCurEvent(curId: eventId)
        if e == nil {
            callback(false)
            return
        }

        e!.msgIDList.append(msgId)

        let attris: [String: Any] = [
            "msg": e!.msgIDList,
        ]
        updateEvent(e!, attris: attris, callback: callback)
    }
}












