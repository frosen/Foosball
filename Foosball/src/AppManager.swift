//
//  Director.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import Foundation

class AppManager: NSObject {

    var user: User? = nil

    //单例
    static let shareInstance = AppManager()
    private override init() {
        print("初始化导演类")
    }

    //在所有之前调用
    func onStart() {
        //读取配置文件

        //假数据
        user = User(ID: DataID(ID: 123))

        var e: Event! = nil
        e = Event(ID: DataID(ID: 50001), item: Foosball)
        user!.activeEvents.append(e)
        e = Event(ID: DataID(ID: 50001), item: Foosball)
        user!.activeEvents.append(e)

        user!.avatarURL = "http://img4.duitang.com/uploads/item/201501/16/20150116231413_KQdLM.jpeg"
    }

    
}
