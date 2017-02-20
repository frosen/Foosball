//
//  User.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class User: BaseData {
    static let classname = "_User"

    //个人信息
    var name: String = "玩家"
    var sign: String = "个性签名，啦啦啦"
    var avatarURL: String = ""
    var sex: Int = 0 // 0保密，1男，2女
    var isRegistered: Bool = false

    //状态数据

    convenience init(ID: DataID, name: String, url: String) {
        self.init(ID: ID)
        self.name = name
        self.avatarURL = url
    }

    override init(ID: DataID) {
        super.init(ID: ID)
    }
}


