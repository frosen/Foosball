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

    override init() {
        super.init()
        print("初始化 ActiveEventsMgr")

        // 读取本地数据

        var e: Event! = nil
        e = Event(ID: DataID(ID: 50001))

        //自己方
        let bb1 = UserBrief(ID: DataID(ID: 1232))
        bb1.name = "小明1"
        let p1 = UserState(user: bb1, state: .invite)

        let bb2 = UserBrief(ID: DataID(ID: 123))
        bb2.name = "小明2"
        let p2 = UserState(user: bb2, state: .ongoing)

        let bb3 = UserBrief(ID: DataID(ID: 1232))
        bb3.name = "小明3"
        let p3 = UserState(user: bb3, state: .waiting)

        let bb12 = UserBrief(ID: DataID(ID: 1232))
        bb12.name = "明a"
        let p12 = UserState(user: bb12, state: .win)

        let bb22 = UserBrief(ID: DataID(ID: 1232))
        bb22.name = "明b"
        let p22 = UserState(user: bb22, state: .lose)

        let bb32 = UserBrief(ID: DataID(ID: 1232))
        bb32.name = "明3"
        let p32 = UserState(user: bb32, state: .finish)

        let bb321 = UserBrief(ID: DataID(ID: 1232))
        bb321.name = "明4"
        let p321 = UserState(user: bb321, state: .keepImpeach)

        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]

        // 对方
        let bk1 = UserBrief(ID: DataID(ID: 1232))
        bk1.name = "小王a"
        let pk1 = UserState(user: bk1, state: .invite)

        let bk2 = UserBrief(ID: DataID(ID: 1232))
        bk2.name = "小王b"
        let pk2 = UserState(user: bk2, state: .invite)

        let bk3 = UserBrief(ID: DataID(ID: 1232))
        bk3.name = "大王c"
        let pk3 = UserState(user: bk3, state: .invite)

        e.opponentStateList = [pk1, pk2, pk3]


        e.imageURLList = ["http://up.qqjia.com/z/25/tu32700_3.png", "http://up.qqjia.com/z/25/tu32718_6.png", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg"]

        e.detail = "~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；"

        e.wager = [(1, 0, 0)] 

        let m1 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么1")
        let m2 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么2")
        let m3 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么3")
        let m4 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么4")
        let m5 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5 你说什么5")

        let ot = OperationTime(userId: DataID(ID: 123), time: Time.now, toState: .honoured)
        e.operationTimeList.append(ot)

        e.location = Location(l: CLLocation(latitude: 39, longitude: 115))
        e.time = Time(timeIntervalSinceNow: 136000)

        data = []

        e.msgList = [m1, m2, m3, m4, m5]
        data.append(e)
        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        e = Event(ID: DataID(ID: 50001))
        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]
        e.opponentStateList = [pk1, pk2, pk3]
        data.append(e)

        // 初始化时候直接启动轮询
    }

    // 记录每个事件更新时，状态和对话数的变化
    private(set) var eventChangeMap: [Event: (Bool, Int)] = [:]
    func clearEventChange(_ e: Event) {
        eventChangeMap.removeValue(forKey: e)
    }

    override func changeData(changeFunc: (([Event]) -> AnyObject?), needUpload: Bool) {
        // 接受新变化，并获取那个event更新了状态和对话数
        if let change = changeFunc(data) as? [Event: (Bool, Int)] {
            eventChangeMap = change
        }

        updateObserver()
        saveData(needUpload: needUpload)
    }

    override func initObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onInit(activeEvents: data)
    }

    override func modifyObserver(_ ob: ActiveEventsMgrObserver) {
        ob.onModify(activeEvents: data)
    }

}
