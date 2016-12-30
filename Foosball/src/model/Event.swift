//
//  Event.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

enum EventType: Int {
    case confrontation //对决
    case melee //混战
    case challenge //挑战
    case makeFriend //交友
    case beApprentice //拜师
}

enum EventState {
    case invite //接收到邀请，可以同意，或拒绝（会让发送拒绝消息）
    case ready //生成后在到达比赛时间前的状态，可邀请，或取消
    case ongoing //比赛开始后，可确认胜利还是失败

    case win //胜利，确认对方是否兑现
    case lose //失败，确认是否自己已经完成了承诺的兑现
    case waiting //你确认成败后，别人没确认前，要等待，最多24小时，到时没确认的自动根据你的确认而确认，1小时后可催对方，此时你的数值还是保持win，lose

    case honoured //已兑现，选择评价，或直接完成
    case finish //确认后完成，不再提示

    case impeach //当确认成败时，如果有人已经确定并与你不符时，会提示，如果你确认则进入存疑状态，保持或重选，此时你的数值还是保持win，lose
    case keepImpeach_win //保持存疑状态，不再提示
    case keepImpeach_lose //保持存疑状态，不再提示
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
    var userId: DataID
    var time: Time
    var toState: EventState
    init(userId: DataID, time: Time, toState: EventState) {
        self.userId = userId
        self.time = time
        self.toState = toState
    }
}

class MsgStruct {
    var user: UserBrief
    var time: Time
    var msg: String = ""

    init(user: UserBrief, time: Time, msg: String) {
        self.user = user
        self.time = time
        self.msg = msg
    }
}

class Event: BaseData {
    //类型 对决 乱斗 挑战 求教 会友
    var type: EventType = .confrontation

    //项目
    var item: ItemType = ItemType.list[0]

    //人数 不同类型下表示的不一样 -1代表不限
    var memberCount: Int = -1
    var memberCount2: Int = -1

    //其他人是否可以增加新人 对决为false，其他为true，如果为true还能设置人数上限，默认不限
    var canInvite: Bool = false

    //比赛时间或者截止时间（对于挑战）
    var time: Time! = nil

    //位置信息
    var location: Location! = nil

    //是否发布到了地图上，也就是别人任意人可以加入
    var isPublishToMap: Bool = false

    //奖杯（兑现物）, 根据序号，在WagerList查询
    var wager: [(Int, Int, Int)] = []

    //详情
    var detail: String = ""

    //生成后可以继续修改的数据 ---------------------------------
    //自己方以及状态
    var ourSideStateList: [UserState] = []

    //对方以及状态
    var opponentStateList: [UserState] = []

    //图片列表
    var imageURLList: [String] = []

    //对话list
    var msgList: [MsgStruct] = []

    //被动修改的数据 -------------------------------------------
    //操作时间
    var operationTimeList: [OperationTime] = []
}
