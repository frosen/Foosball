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

class UserMgr: NSObject, DataMgr {

    typealias DATA = User
    typealias OB = UserMgrObserver

    //数据
    var user: DATA! = nil

    // 逻辑数据
    private class ObStruct {
        var ob: OB
        var hide: Bool = false
        var needUpdata: Bool = false
        init(ob: OB) {
            self.ob = ob
        }
    }
    private var obDict: [String: ObStruct] = [:]

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
    func register(observer ob: OB, key: String) {
        obDict[key] = ObStruct(ob: ob)
        ob.onInit(user: user)
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
    }

    //显示和隐藏
    func set(hide: Bool, key: String) {
        let obStru = obDict[key]!
        if hide == false && obStru.hide == true && obStru.needUpdata == true {
            obStru.needUpdata = false
            obStru.ob.onModify(user: user)
        }
        obStru.hide = hide
    }

    // 变化数据
    func changeData(changeFunc: ((DATA) -> Void), needUpload: Bool = false) {

        // 接受新变化
        changeFunc(user)

        // 在每个观察者中进行对比
        for obTup in self.obDict {
            let obStru = obTup.value
            if obStru.hide {
                obStru.needUpdata = true
            } else {
                obStru.ob.onModify(user: user)
            }
        }

        //保存本地
        
        if needUpload { //上传网络
            
        }
    }
}
