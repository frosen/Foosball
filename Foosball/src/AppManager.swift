//
//  Director.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import Foundation

class AppManager: NSObject {

    var user: User? = nil

    //单例
    static let shareInstance = AppManager()
    fileprivate override init() {
        print("初始化导演类")
    }

    //在所有之前调用
    func onStart() {
        //读取配置文件

        //假数据
        user = User(ID: DataID(ID: 123))

        var e: Event! = nil
        e = Event(ID: DataID(ID: 50001), item: Foosball)

        //自己方
        let bb1 = UserBrief(ID: DataID(ID: 1232))
        bb1.name = "小明"
        let p1 = UserState(user: bb1, state: .invite)

        let bb2 = UserBrief(ID: DataID(ID: 1232))
        bb2.name = "小明2"
        let p2 = UserState(user: bb2, state: .ongoing)

        let bb3 = UserBrief(ID: DataID(ID: 1232))
        bb3.name = "小明3"
        let p3 = UserState(user: bb3, state: .waiting)

        let bb12 = UserBrief(ID: DataID(ID: 1232))
        bb12.name = "明"
        let p12 = UserState(user: bb12, state: .win)

        let bb22 = UserBrief(ID: DataID(ID: 1232))
        bb22.name = "明2"
        let p22 = UserState(user: bb22, state: .lose)

        let bb32 = UserBrief(ID: DataID(ID: 1232))
        bb32.name = "明3"
        let p32 = UserState(user: bb32, state: .finish)

        let bb321 = UserBrief(ID: DataID(ID: 1232))
        bb321.name = "明3"
        let p321 = UserState(user: bb321, state: .keepImpeach)

        e.ourSideStateList = [p1, p2, p3, p12, p22, p32, p321]

        // 对方
        let bk1 = UserBrief(ID: DataID(ID: 1232))
        bk1.name = "小明"
        let pk1 = UserState(user: bk1, state: .invite)

        let bk2 = UserBrief(ID: DataID(ID: 1232))
        bk2.name = "小明2"
        let pk2 = UserState(user: bk2, state: .invite)

        let bk3 = UserBrief(ID: DataID(ID: 1232))
        bk3.name = "小明3"
        let pk3 = UserState(user: bk3, state: .invite)

        e.opponentStateList = [pk1, pk2, pk3]


        e.imageURLList = ["http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg", "http://img.asdf/asdf.jpg"]

        e.detail = "~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；"

        e.award = "~ 红牛杯----胜者每人获得一瓶红牛饮料。\n以上费用败者承担，必须兑现！！"

        let m1 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么")
        let m2 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么\n~ 这是一首简单的小情歌；\n~ 这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首简单的小情歌；这是一首")
        let m3 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么")
        let m4 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么")
        let m5 = MsgStruct(user: bk3, time: Time.now, msg: "你说什么")

        e.msgList = [m1, m2, m3, m4, m5]
        user!.activeEvents.append(e)
        e = Event(ID: DataID(ID: 50001), item: Foosball)
        user!.activeEvents.append(e)

//        user!.avatarURL = "http://img4.duitang.com/uploads/item/201501/16/20150116231413_KQdLM.jpeg"
    }

    
}
