//
//  User.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class UserBrief: BaseData {
    //名字
    var name: String = ""

    //头像url
    var avatarURL: String = ""
    
}

class User: BaseData {
    //登录信息
    var loginName: String = "" //手机号或者设备号
    var passwd: String = "" //或者token

    //个人信息
    var name: String = ""
    var avatarURL: String = ""

    //状态数据

    //活动事件列表
    var activeEvents: [Event] = []

    //全部事件列表
    var events: [Event]? = nil

    //好友概要列表
    var firends: [UserBrief]? = nil
}

extension User {
    func getBrief() -> UserBrief {
        let br = UserBrief(ID: ID)
        br.name = name
        br.avatarURL = avatarURL
        return br
    }
}


