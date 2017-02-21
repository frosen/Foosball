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
    private(set) var userMgr: UserMgr! = nil
    private(set) var activeEventsMgr: ActiveEventsMgr! = nil
    private(set) var msgMgr: MsgMgr! = nil
    private(set) var labelMgr: LabelMgr! = nil
    private(set) var errorMgr: ErrorMgr! = nil

    //单例
    fileprivate static let shareInstance = AppManager()
    fileprivate override init() {
        print("初始化导演类")
        super.init()
    }

    func setGlobal() {
        print("全局设置")

        AMapServices.shared().apiKey = "04ec496139134f937690624ac77f2363"
        AMapServices.shared().enableHTTPS = true

        userMgr = UserMgr()
        activeEventsMgr = ActiveEventsMgr()
        msgMgr = MsgMgr()
        labelMgr = LabelMgr()
        errorMgr = ErrorMgr()

        userMgr.run()
        activeEventsMgr.run()
    }
}

var APP: AppManager {
    return AppManager.shareInstance
}
