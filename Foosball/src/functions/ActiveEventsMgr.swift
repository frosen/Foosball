//
//  ActiveEventsMgr.swift
//  Foosball
//  活动事件管理器
//  某个view可以在此注册一个function，当data有变化时，运行每个注册的function，如果是有变化的，则变化相应的view
//  Created by luleyan on 2016/10/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol ActiveEventsMgrObserver {
    func onInit(activeEvents: [Event])
    func onModify(activeEvents: [Event])
}

class ActiveEventsMgr: DataMgr<[Event], ActiveEventsMgrObserver> {

    let SAVE_NAME: String = "event"

    override init() {
        super.init()
        print("初始化 ActiveEventsMgr")

        // 读取本地数据

        //自己方
        let bb1 = UserBrief(ID: DataID(ID: "1232"))
        bb1.name = "小明1"
        let p1 = UserState(user: bb1, state: .invite)

        let bb2 = UserBrief(ID: DataID(ID: "123"))
        bb2.name = "小明2"
        let p2 = UserState(user: bb2, state: .ongoing)

        let bb3 = UserBrief(ID: DataID(ID: "1232"))
        bb3.name = "小明3"
        let p3 = UserState(user: bb3, state: .waiting)

        let bb12 = UserBrief(ID: DataID(ID: "1232"))
        bb12.name = "明a"
        let p12 = UserState(user: bb12, state: .win)

        let bb22 = UserBrief(ID: DataID(ID: "1232"))
        bb22.name = "明b"
        let p22 = UserState(user: bb22, state: .lose)

        let bb32 = UserBrief(ID: DataID(ID: "1232"))
        bb32.name = "明3"
        let p32 = UserState(user: bb32, state: .finish)

        let bb321 = UserBrief(ID: DataID(ID: "1232"))
        bb321.name = "明4"
        let p321 = UserState(user: bb321, state: .finish)



        // 对方
        let bk1 = UserBrief(ID: DataID(ID: "1232"))
        bk1.name = "小王a"
        let pk1 = UserState(user: bk1, state: .invite)

        let bk2 = UserBrief(ID: DataID(ID: "1232"))
        bk2.name = "小王b"
        let pk2 = UserState(user: bk2, state: .invite)

        let bk3 = UserBrief(ID: DataID(ID: "1232"))
        bk3.name = "大王c"
        let pk3 = UserState(user: bk3, state: .invite)

        data = []
        var e: Event! = nil

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.append(e)

        // -----------------
        e = Event(ID: DataID(ID: "50001"))

        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]

        e.imageURLList = ["http://up.qqjia.com/z/25/tu32700_3.png", "http://up.qqjia.com/z/25/tu32718_6.png", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg"]

        e.detail = "~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；"

        e.wager = [(1, 0, 0)] 

        let m1 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么1")
        let m2 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么2")
        let m3 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么3")
        let m4 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么4")
        let m5 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5")

        e.createTime = Time.now
        e.createUserID = DataID(ID: "123")

        e.location = Location()
        e.location.loc = CLLocation()
        e.location.locString = "hehe"
        e.time = Time(timeIntervalSinceNow: 136000)

        e.msgList = [m1, m2, m3, m4, m5,
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1说什么5 你说什么5 你说什么5 你说什么5 你说 zv说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "你说什么1"),
        ]
        data.append(e)
    }

    // 记录每个事件更新时，状态和对话数的变化
    private(set) var eventChangeMap: [Event: (Bool, Int)] = [:]
    func clearEventChange(_ e: Event) {
        eventChangeMap.removeValue(forKey: e)
    }

    override func handleChangeResult(_ res: AnyObject) {
        eventChangeMap = res as! [Event: (Bool, Int)]
    }

    // ---------------------------------------------------------

    func addNewEvent(_ e: Event, callback: @escaping ((Bool, Error?) -> Void)) {
        let attris: [(String, Any)] = [
            ("tp", e.type.rawValue),
            ("i", e.item.tag),
            ("mc1", e.memberCount),
            ("mc2", e.memberCount2),
            ("ivt", e.canInvite),
            ("tm", e.time.time),
            ("loc", e.location.loc),
            ("p2m", e.isPublishToMap),
            ("wg", Serializer.wagersToList(e.wager)),
            ("dtl", e.detail),
            ("our", Serializer.userStatesToList(e.ourSideStateList)),
            ("opp", Serializer.userStatesToList(e.opponentStateList)),
            ("img", e.imageURLList),
            ("msg", []),
            ("ctm", e.createTime.time),
            ("cid", e.createUserID.rawValue)
        ]

        Network.shareInstance.createObj(to: SAVE_NAME, attris: attris) { suc, error in
            print("create event on net: \(suc), ", error ?? "no error")
            callback(suc, error)
        }
    }

    // set ob --------------------------------------------------

    override func initObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onInit(activeEvents: data)
    }

    override func modifyObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onModify(activeEvents: data)
    }

}

class Serializer: NSObject {
    class func wagersToList(_ wagers: [(Int, Int, Int)]) -> [Int] {
        var list: [Int] = []
        for wager in wagers {
            list.append(wager.0)
            list.append(wager.1)
            list.append(wager.2)
        }
        return list
    }

    class func wager(from list: [Int]) -> [(Int, Int, Int)] {
        return []
    }

    // -------------------------------------------------------

    class func userStatesToList(_ userStates: [UserState]) -> [[String: Any]] {
        var list: [[String: Any]] = []
        for userState in userStates {
            list.append([
                "id": userState.user.ID.rawValue,
                "st": userState.state.rawValue
            ])
        }

        return list
    }
}












