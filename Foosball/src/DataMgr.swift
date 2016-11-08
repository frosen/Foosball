//
//  DataMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DataMgr<DATA, OB> {

    func register(observer ob: OB, key: String) {

    }

    func unregister(key: String) {

    }
    
    func set(hide: Bool, key: String) //显示和隐藏
    func changeData(changeFunc: ((DATA) -> Void), needUpload: Bool)
}
