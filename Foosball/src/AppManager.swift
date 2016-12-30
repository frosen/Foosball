//
//  Director.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import Foundation

class AppManager: NSObject {

    // 数据管理器
    let userMgr: UserMgr
    let activeEventsMgr: ActiveEventsMgr

    //单例
    fileprivate static let shareInstance = AppManager()
    fileprivate override init() {
        print("初始化导演类")

        ItemType.initAllItem()
        userMgr = UserMgr()
        activeEventsMgr = ActiveEventsMgr()

        super.init()

        AMapServices.shared().apiKey = "04ec496139134f937690624ac77f2363"
        AMapServices.shared().enableHTTPS = true
    }
}

var APP: AppManager {
    return AppManager.shareInstance
}
