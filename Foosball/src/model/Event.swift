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
    var user: User
    var state: EventState
    init(user: User, state: EventState) {
        self.user = user
        self.state = state
    }
}

class Event: DataCore {
    //类型 对决 乱斗 挑战 求教 会友
    //    var type: EventType

    //项目
    var item: ItemType

    //其他人是否可以增加新人 对决为false，其他为true，如果为true还能设置人数上限，默认不限

    //发送方以及状态
    var senderStateList: [UserState] = []

    //接收方以及状态
    var receiverStateList: [UserState] = []

    //位置信息

    //操作时间

    //兑现物

    //对话list



    init(id: DataID, item: ItemType) {
        self.item = item
        super.init(ID: id)

    }
}
