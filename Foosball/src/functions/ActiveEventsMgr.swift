//
//  ActiveEventsMgr.swift
//  Foosball
//  活动事件管理器
//  某个view可以在此注册一个function，当data有变化时，运行每个注册的function，如果是有变化的，则变化相应的view
//  Created by luleyan on 2016/10/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol ActiveEventsMgrObserver {

    // 检测数据是否调整了
    func checkDataModify(oldData: [Event], newData: [Event]) -> [String: String]

    // 数据调整后出发的方法
    func onDataModify(newData: [Event], resDict: [String: String])
}

class ActiveEventsMgr: NSObject {

    // 数据
    var activeEvents: [Event] = []

    // 逻辑数据
    var changeDataThread: DispatchQueue! = nil
    var obDict: [String: ActiveEventsMgrObserver] = [:]

    //单例
    static let shareInstance = ActiveEventsMgr()

    fileprivate override init() {
        super.init()

        // 读取本地数据

        // 初始化时候直接启动轮询

        // 初始化解析线程
        changeDataThread = DispatchQueue(label: "ActiveEventsMgr")
    }

    //注册和注销观察者
    func register(observer ob: ActiveEventsMgrObserver, key: String) {
        obDict[key] = ob
        ob.onDataModify(newData: activeEvents, resDict: [:])
    }

    func unregister(key: String) {
        obDict.removeValue(forKey: key)
    }

    // 变化数据
    func changeData(changeFunc: @escaping (([Event]) -> Void), needUpload: Bool = false) {
        changeDataThread.async {
            // 复制
            var newData: [Event] = []
            for event in self.activeEvents {
                let newE = event.copy() as! Event
                newData.append(newE)
            }

            // 接受新变化
            changeFunc(newData)

            // 在每个观察者中进行对比
            for obTup in self.obDict {
                let k = obTup.key
                let ob = obTup.value
                let resDict = ob.checkDataModify(oldData: self.activeEvents, newData: newData)
                if resDict.count > 0 {
                    DispatchQueue.main.async {
                        // 由于跨线程有延迟，再验证一遍是否被释放了
                        if self.obDict[k] != nil {
                            ob.onDataModify(newData: newData, resDict: resDict)
                        } else {
                            print("已经释放：", k)
                        }
                    }
                }
            }

            self.activeEvents = newData

            //保存本地

            if needUpload { //上传网络

            }
        }
    }
}
