//
//  UserMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/5.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol UserMgrObserver {
    func onInit(user: User)
    func onModify(user: User)
}

class UserMgr: DataMgr<User, UserMgrObserver> {


    override init() {
        super.init()
        print("初始化 UserMgr")

        // 读取本地数据
        data = User(ID: DataID(ID: 123))
        data.name = "聂小倩"
        data.avatarURL = ""

        // 初始化时候直接启动轮询
    }

    override func initObserver(_ ob: UserMgrObserver) {
        ob.onInit(user: data)
    }

    override func modifyObserver(_ ob: UserMgrObserver) {
        ob.onModify(user: data)
    }
}
