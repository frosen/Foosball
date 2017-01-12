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

    //登录信息，不可以又用户改变
    var loginName = ""
    var password = ""


    func getBrief() -> UserBrief {
        let br = UserBrief(ID: ID)
        br.name = name
        br.avatarURL = avatarURL
        return br
    }
}


