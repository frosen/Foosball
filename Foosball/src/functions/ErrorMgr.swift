//
//  ErrorMgr.swift
//  Foosball
//
//  Created by luleyan on 2017/1/23.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

protocol ErrorMgrObserver {
    func onError()
}

class ErrorMgr: NSObject {
    override init() {
        super.init()
        print("初始化 ErrorMgr")
    }

    func run() {
        
    }

    private(set) var obDict: [String: ErrorMgrObserver] = [:]

    func register(observer ob: ErrorMgrObserver, key: String) {
        obDict[key] = ob
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
    }

    // 报错 -----------------------------------------------------------

    func hasError() {
        for obTup in obDict {
            obTup.value.onError()
        }
    }
}
