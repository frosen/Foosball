//
//  UserMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/5.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol UserMgrObserver {

    // 数据调整后出发的方法
    func onModify(user: User, isInit: Bool)
}

class UserMgr: NSObject {

    //数据
    var user: User! = nil

    // 逻辑数据
    var obDict: [String: UserMgrObserver] = [:]

    override init() {
        super.init()
        print("初始化 UserMgr")

        // 读取本地数据
        user = User(ID: DataID(ID: 123))
        user.name = "聂小倩"
        user.avatarURL = ""

        // 初始化时候直接启动轮询
    }

    //注册和注销观察者
    func register(observer ob: UserMgrObserver, key: String) {
        obDict[key] = ob
        ob.onModify(user: user, isInit: true)
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
    }

    // 变化数据
    func changeData(changeFunc: ((User) -> Void), needUpload: Bool = false) {

        // 接受新变化
        changeFunc(user)

        // 在每个观察者中进行对比
        for obTup in self.obDict {
            obTup.value.onModify(user: user, isInit: false)
        }

        //保存本地
        
        if needUpload { //上传网络
            
        }
    }
}
