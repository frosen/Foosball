//
//  ActiveEventsMgr.swift
//  Foosball
//  活动事件管理器
//  某个view可以在此注册一个function，当data有变化时，运行每个注册的function，如果是有变化的，则变化相应的view
//  Created by luleyan on 2016/10/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

// 为了提高每次刷新的效率，复用data中的event，数量不足才新建，否则只修改已经创建好的
// 用eventCount记录有效event数量，超过的event不删除也没有用
class ActEvents {
    private(set) var count: Int = 0
    private(set) var eList: [Event] = []

    func clean() {
        count = 0 // 不用真正的清空，用数量值表示即可，留下无用的event复用避免create时损失效率
    }

    func add() -> Event {
        count += 1
        if count > eList.count {
            for _ in 0 ..< count - eList.count {
                eList.append(Event(ID: DataID(ID: "?")))
            }
        }

        return eList[count - 1]
    }

    func add(e: Event) {
        if eList.count > count {
            eList[count] = e
        } else {
            if eList.count < count {
                for _ in 0 ..< count - eList.count {
                    eList.append(Event(ID: DataID(ID: "?")))
                }
            }
            eList.append(e)
        }

        count += 1
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
        "our": [["key": "value"]],
        "opp": [["key": "value"]],
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

        //自己方
        let bb1 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        let p1 = UserState(user: bb1, state: .invite)

        let bb2 = UserBrief(ID: DataID(ID: "123"), name: "佐助", url: "")
        bb2.name = "小明2"
        let p2 = UserState(user: bb2, state: .ongoing)

        let bb3 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb3.name = "小明3"
        let p3 = UserState(user: bb3, state: .waiting)

        let bb12 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb12.name = "明a"
        let p12 = UserState(user: bb12, state: .win)

        let bb22 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb22.name = "明b"
        let p22 = UserState(user: bb22, state: .lose)

        let bb32 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb32.name = "明3"
        let p32 = UserState(user: bb32, state: .finish)

        let bb321 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bb321.name = "明4"
        let p321 = UserState(user: bb321, state: .finish)



        // 对方
        let bk1 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bk1.name = "小王a"
        let pk1 = UserState(user: bk1, state: .invite)

        let bk2 = UserBrief(ID: DataID(ID: "123"), name: "佐助", url: "")
        bk2.name = "小王b"
        let pk2 = UserState(user: bk2, state: .invite)

        let bk3 = UserBrief(ID: DataID(ID: "1232"), name: "佐助", url: "")
        bk3.name = "大王c"
        let pk3 = UserState(user: bk3, state: .invite)

        var e: Event! = nil

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e: e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)
//
//        e = Event(ID: DataID(ID: 50001))
//        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
//        e.opponentStateList = [pk1, pk2, pk3]
//        data.add(e)

        // -----------------
        e = Event(ID: DataID(ID: "50001"))

        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]

        e.imageURLList = ["http://up.qqjia.com/z/25/tu32700_3.png", "http://up.qqjia.com/z/25/tu32718_6.png", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg"]

        e.detail = "~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；"

        e.wagerList = [Wager(str: "红牛")]

        let m1 = MsgStruct(user: bk3, time: Time.now, msg: "1你说什么1")
        let m2 = MsgStruct(user: bk2, time: Time.now, msg: "2你说什么2")
        let m3 = MsgStruct(user: bk1, time: Time.now, msg: "3你说什么3")
        let m4 = MsgStruct(user: bk3, time: Time.now, msg: "4你说什么4")
        let m5 = MsgStruct(user: bk2, time: Time.now, msg: "5你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么6 你说什么5 你说什么7 你说什么5 你说什么9 你说什么5 你说什么0 你说什么5 你说什么00 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5")

        e.createTime = Time.now
        e.createUserID = DataID(ID: "123")

        e.location = Location()

        e.time = Time(timeIntervalSinceNow: 136000)

        e.msgList = [m1, m2, m3, m4, m5,
            MsgStruct(user: bk1, time: Time.now, msg: "6你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说什么"),
            MsgStruct(user: bk3, time: Time.now, msg: "7你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk2, time: Time.now, msg: "8你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk1, time: Time.now, msg: "9你说什么1"),
            MsgStruct(user: bk3, time: Time.now, msg: "10你说什么1"),
            MsgStruct(user: bk2, time: Time.now, msg: "1你说什么1说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk1, time: Time.now, msg: "2你说什么1 说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk3, time: Time.now, msg: "3你说什么1"),
            MsgStruct(user: bk1, time: Time.now, msg: "4你说什么1说什么5 你说什么5 你说什么5 你说什么5 你说 zv说什么5 你说什么5 你说什么5 你说什么5 你说"),
            MsgStruct(user: bk2, time: Time.now, msg: "5你说什么1"),
        ]
        data.add(e: e)
    }

    // 记录每个事件更新时，状态和对话数的变化
    private(set) var eventChangeMap: [Event: (Bool, Int)] = [:]
    func clearEventChange(_ e: Event) {
        eventChangeMap.removeValue(forKey: e)
    }

    override func handleChangeResult(_ res: AnyObject) {
        eventChangeMap = res as! [Event: (Bool, Int)]
    }

    // 刷新数据时调用 ---------------------------------------------

    func cleanData() {
        data.clean()
    }

    func addNewData(_ attris: [String: Any]) {
        let e = data.add()

        e.ID = DataID(ID: attris["id"] as! DataID.IDType)
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
    }

    // set ob --------------------------------------------------

    override func initObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onInit(actE: data)
    }

    override func modifyObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onModify(actE: data)
    }

    // ---------------------------------------------------------

    func addNewEvent(_ e: Event, callback: @escaping ((Bool, Error?) -> Void)) {
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
                e.ID = DataID(ID: newID)
                self.data.add(e: e)
                APP.userMgr.addNewEvent(e) { suc, error in
                    if suc {
                        self.updateObserver()
                        self.saveData()
                    }
                    callback(suc, error)
                }
            } else {
                callback(suc, error)
            }
        }
    }
}












