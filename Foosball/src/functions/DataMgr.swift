//
//  DataMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DataMgr<DATA, OB>: NSObject {

    //数据
    var data: DATA! = nil

    // 逻辑数据 观察者，是否隐藏，是否需要刷新
    private var obDict: [String: (OB, Bool, Bool)] = [:]

    func register(observer ob: OB, key: String) {
        obDict[key] = (ob, false, false)
        initObserver(ob)
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
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

    func changeData(changeFunc: ((DATA) -> AnyObject?), needUpload: Bool = false) {
        // 接受新变化
        let _ = changeFunc(data)

        updateObserver()
        saveData(needUpload: needUpload)
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

    func saveData(needUpload: Bool = false) {
        //保存本地

        if needUpload { //上传网络

        }
    }

    // 需要继承
    func initObserver(_ ob: OB) {}
    func modifyObserver(_ ob: OB) {}
}
