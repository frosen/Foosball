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

// 差异

enum EventState: Int {
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
    var user: User
    var state: EventState
    init(user: User, state: EventState) {
        self.user = user
        self.state = state
    }
}

class Wager {
    var str: String
    var data: (Int, Int, Int) = (1, 0, 0)

    init(str: String? = nil) {
        if str == nil {
            self.str = ""
        } else {
            self.str = str!
        }
    }

    var toString: String {
        return str
    }

    static let NameList: [(String, [(String, [String])])] = [
        ("饭", [
            ("早餐", [
                "中餐", "洋快餐", "烤串", "大盘鸡",
                ]),
            ("午餐", [
                "中餐", "洋快餐", "烤串", "大盘鸡",
                ]),
            ("晚餐", [
                "中餐", "洋快餐", "烤串", "大盘鸡",
                ])
            ]),
        ("饮料", [
            ("红牛", [
                "一瓶", "两瓶", "三瓶", "四瓶", "五瓶",
                ]),
            ("红茶", [
                "一瓶", "两瓶", "三瓶", "四瓶", "五瓶",
                ]),
            ("绿茶", [
                "一瓶", "两瓶", "三瓶", "四瓶", "五瓶",
                ]),
            ]),
        ("其他", [("", [""])]),
        
        ]
}

class MsgStruct: BaseData {
    static let classname = "msg"

    var user: User? = nil
    var time: Time? = nil
    var msg: String = ""

    init(id: DataID, user: User, time: Time, msg: String) {
        super.init(ID: id)
        self.user = user
        self.time = time
        self.msg = msg
    }

    override init(ID: DataID) {
        super.init(ID: ID)
    }
}

class Event: BaseData {
    static let classname = "event"

    //类型 对决 乱斗 挑战 求教 会友
    var type: EventType = .confrontation

    //项目
    var item: ItemType = ItemType.list[0]

    //人数 不同类型下表示的不一样 -1代表不限
    var memberCount: Int = -1
    var memberCount2: Int = -1

    //其他人是否可以增加新人 对决为false，其他为true，如果为true还能设置人数上限，默认不限
    var canInvite: Bool = true

    //比赛时间或者截止时间（对于挑战）
    var time: Time = Time()

    //位置信息
    var location: Location = Location()

    //是否发布到了地图上，也就是别人任意人可以加入
    var isPublishToMap: Bool = false

    //奖杯（兑现物）, 根据序号，在WagerList查询
    var wagerList: [Wager] = []

    //详情
    var detail: String = ""

    //生成后可以继续修改的数据 ---------------------------------
    //自己方以及状态
    var ourSideStateList: [UserState] = []

    //对方以及状态
    var opponentStateList: [UserState] = []

    //图片列表
    var imageURLList: [String] = []

    //对话list // 由于数据量大，先保持id，再根据id获取
    var msgIDList: [DataID.IDType] = []
    var msgList: [MsgStruct] = []

    //被动生成的数据 -------------------------------------------
    var createTime: Time! = nil
    var createUserID: DataID! = nil
}
