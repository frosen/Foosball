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
    var name: String

    //头像url
    var avatarURL: String

    init(ID: DataID, name: String, url: String) {
        self.name = name
        self.avatarURL = url
        super.init(ID: ID)
    }
}

class User: BaseData {

    //个人信息
    var name: String = "玩家"
    var sign: String = "个性签名，啦啦啦"
    var avatarURL: String = ""
    var isRegistered: Bool = false

    //状态数据

    // 获取用户信息摘要
    func getBrief() -> UserBrief {
        let br = UserBrief(ID: ID, name: name, url: avatarURL)
        return br
    }
}


