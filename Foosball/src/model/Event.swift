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
    case overtime // 邀请超时，观战 ***only local状态***
    case watch // 观战，作为观战者时的状态，可以退出，或不再提示 ***only local状态*** 发生错误时，也是观战

    case start //生成后在到达比赛时间前的状态，可邀请，或取消
    case ongoing //比赛开始后，可确认胜利还是失败 ***only local状态***

    case win //胜利，确认对方是否兑现
    case lose //失败，确认是否自己已经完成了承诺的兑现

    case waitConfirm //你确认成败后，别人没确认前，要等待，最多24小时，到时没确认的自动根据你的确认而确认，可发消息催对方，此时你的数值还是保持win，lose ***only local状态***
    case controversy //当确认成败时，如果有人已经确定并与你不符时，会提示，如果你确认则进入争议状态，保持或重选 ***only local状态***
    case rechoose //重选，确认胜利失败

    case finish_win //确认胜利并且获得兑现，追加聊天，不再提示
    case finish_lose // 确认失败并且兑现，追加聊天，不再提示

    case keepControversy_win //保持争议状态，重选，不再提示
    case keepControversy_lose //保持争议状态，重选，不再提示

    case impeachEnd //保持争议时，发现对方修改了，没有争议了，可完成 ***only local状态*** ，不再提示

    static let onlyLocalState: [EventState] = [.overtime, .watch, .ongoing, .waitConfirm, .controversy, .impeachEnd]
    static let noTipState: [EventState] = [.finish_win, .finish_lose, .keepControversy_win, .keepControversy_lose, .impeachEnd]
}

class UserState {
    var user: User
    var state: EventState
    init(user: User, state: EventState) {
        self.user = user
        self.state = state
    }
}

class Promise {
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
    var item: String = ""

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

    //奖杯（兑现物）, 根据序号，在PromiseList查询
    var promiseList: [Promise] = []

    //详情
    var detail: String = ""

    //生成后可以继续修改的数据 ---------------------------------
    //自己方以及状态
    var ourSideStateList: [UserState] = []

    //对方以及状态
    var opponentStateList: [UserState] = []

    //观战者以及状态（只有start和finish_win)
    var obStateList: [UserState] = []

    //图片列表
    var imageURLList: [String] = []

    //对话list // 由于数据量大，先保持id，再根据id获取
    var msgIDList: [DataID.IDType] = []

    //被动生成的数据 -------------------------------------------
    var createTime: Time! = nil
    var createUserID: DataID! = nil

    var firstConfirmTime: Time? = nil // 用于第一个人确定胜败后倒计时
    var firstConfirmUserID: DataID? = nil

    //便捷函数 -------------------------------------------------

    func eachUserState(_ callback: ((UserState) -> Bool)) -> (UserState, Int)? {
        for us in ourSideStateList {
            if callback(us) {
                return (us, 1)
            }
        }

        for us in opponentStateList {
            if callback(us) {
                return (us, 2)
            }
        }

        for us in obStateList {
            if callback(us) {
                return (us, 3)
            }
        }

        return nil
    }
}






