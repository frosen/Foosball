//
//  Event.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

enum EventState {
    case invite //生成时给人发送邀请 g
    case ongoing //邀请接受后 o b p r br
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

// 谁在什么时间转换到了什么状态
class OperationTime {
    var userId: Data
    var time: Time
    var toState: EventState
    init(userId: Data, time: Time, toState: EventState) {
        self.userId = userId
        self.time = time
        self.toState = toState
    }
}

class MsgStruct {
    var user: DataID
    var time: Time
    var msg: String = ""

    init(user: DataID, time: Time, msg: String) {
        self.user = user
        self.time = time
        self.msg = msg
    }
}

class Event: Data {
    //类型 对决 乱斗 挑战 求教 会友
    //    var type: EventType

    //项目
    var item: ItemType

    //人数 不同类型下表示的不一样 -1代表不限
    var memberCount: Int = -1
    var memberCount2: Int = -1

    //其他人是否可以增加新人 对决为false，其他为true，如果为true还能设置人数上限，默认不限
    var canInvite: Bool = false

    //自己方以及状态，第一个肯定是自己
    var ourSideStateList: [UserState] = []

    //对方以及状态
    var opponentStateList: [UserState] = []

    //比赛时间或者截止时间（对于挑战）
    var time: Time? = nil

    //位置信息

    //是否发布到了地图上，也就是别人任意人可以加入
    var isPublishToMap: Bool = false

    //操作时间
    var operationTimeList: [OperationTime] = []

    //奖杯（兑现物）用文本记录就好
    var award: String = ""

    //详情
    var detail: String = ""

    //图片列表
    var imageURLList: [String] = []

    //对话list
    var msgList: [MsgStruct] = []

    init(ID: DataID, item: ItemType) {
        self.item = item
        super.init(ID: ID)

    }
}
