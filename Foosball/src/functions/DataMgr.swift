//
//  DataMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DataMgr<DATA, OB>: NSObject {

    let parseThreadName: String = "data.parse" // 服务器返回数据的解析线程名称

    //数据
    private var _data: DATA! = nil
    var data: DATA! {
        set {
            _data = newValue
        }
        get {
            return _data
        }
    }

    // 逻辑数据 观察者，是否隐藏，是否需要刷新 ----------------------------------------

    private(set) var obDict: [String: (OB, Bool, Bool)] = [:]

    func register(observer ob: OB, key: String, pause: Bool = false) {
        obDict[key] = (ob, pause, false)
        initObserver(ob)
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
    }

    func hasOb(for key: String) -> Bool {
        return obDict[key] != nil
    }
    
    func set(hide: Bool, key: String) {
        if let obTup = obDict[key] {
            if hide == false && obTup.1 == true && obTup.2 == true {
                obDict[key] = (obTup.0, hide, false)
                modifyObserver(obTup.0)
            } else {
                obDict[key] = (obTup.0, hide, obTup.2)
            }
        } else {
            print("no this ob")
        }
    }

    func updateObserver() {
        // 在每个观察者中进行对比
        for obTupTup in obDict {
            let obKey = obTupTup.key
            let obTup = obTupTup.value
            if obTup.1 == true {
                obDict[obKey] = (obTup.0, obTup.1, true)
            } else {
                modifyObserver(obTup.0)
            }
        }
    }

    // 需要继承
    func initObserver(_ ob: OB) {}
    func modifyObserver(_ ob: OB) {}

    // 本地保存 ------------------------------------------------------------

    func saveToLocal() {

    }

    func loadFromLocal() {

    }
}
