//
//  DataManager.swift
//  Foosball
//  某个view可以在此注册一个function，当data有变化时，运行每个注册的function，如果是有变化的，则变化相应的view
//  Created by luleyan on 2016/10/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol DataMgrDelegate {

    // 检测数据是否调整了
    func checkDataModify() -> Bool

    // 数据调整后出发的方法
    func onDataModify()
}

class DataManager: NSObject {
    func go () {
        
    }
}
