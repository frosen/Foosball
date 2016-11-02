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
    //个人信息
    var name: String = "玩家"
    var avatarURL: String = ""

    //状态数据

    // 以下为需要时再获取的数据 -------------------------------------------------------------------------
    //活动事件列表
    

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


