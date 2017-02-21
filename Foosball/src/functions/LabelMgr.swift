//
//  LabelMgr.swift
//  Foosball
//
//  Created by luleyan on 2017/2/21.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class LabelMgrObserver {

}

class LabelMgrData {
    var items: [Label] = []
    var promises: [Label] = []
}

class LabelMgr: DataMgr<LabelMgrData, LabelMgrObserver> {

    override init() {
        super.init()

        data = LabelMgrData()

        loadFromLocal()
        test()
    }

    func test() {
        
    }

    override func loadFromLocal() {
        // 从本地获取，如果没有则说明是第一次获取，则从服务器下载
        
    }
}
