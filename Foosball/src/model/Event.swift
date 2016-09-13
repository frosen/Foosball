//
//  Event.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

enum EventState {
    case invite //生成时给人发送邀请
    case ongoing //邀请接受后
    case refuse
    case confirm
    case cash
    case finish
}

class UserState {
    var user: UserBrief
    var state: EventState
    init(user: UserBrief, state: EventState) {
        self.user = user
        self.state = state
    }
}

class MsgStruct {
    var user: DataID
    var msg: String = ""

    init(user: DataID) {
        self.user = user
    }
}

class Event: DataCore {
    //类型 对决 乱斗 挑战 求教 会友
    //    var type: EventType

    //项目
    var item: ItemType

    //其他人是否可以增加新人 对决为false，其他为true，如果为true还能设置人数上限，默认不限

    //自己方以及状态，第一个肯定是自己
    var ourSideStateList: [UserState] = []

    //对方以及状态
    var opponentStateList: [UserState] = []

    //位置信息

    //操作时间

    //兑现物

    //详情

    //比分列表
    var scoreList: [(Int, Int)] = []

    //对话list
    var msgList: [MsgStruct] = []



    init(ID: DataID, item: ItemType) {
        self.item = item
        super.init(ID: ID)

    }
}
