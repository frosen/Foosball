//
//  Network.swift
//  Foosball
//
//  Created by luleyan on 2016/10/24.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import Foundation
import AVOSCloud

/*
 1. 登录 (手机号或者设备号), (验证码或者token) -> 用户信息
*/

class Network: NSObject {

    //单例
    static let shareInstance = Network()
    private override init() {
        AVOSCloud.setApplicationId("o5nq2XE8H5XUlo9S94F9tioJ-gzGzoHsz", clientKey: "vJrjiBn25QQ4FmvIKhVx8bQ2")
    }

    // 用户相关 --------------------------------------------------------------------

    // 是否已经在本地保存了用户信息
    func hasCurUser() -> Bool {
//        AVUser.logOut()
        let curUser = AVUser.current()
        return curUser?.sessionToken != nil
    }

    func registerUser(id: String, pw: String, attris: [(String, Any)], callback: @escaping ((Bool, Error?, String) -> Void)) {
        let user = AVUser()

        user.username = id
        user.password = pw

        for attri in attris {
            user.setObject(attri.1, forKey: attri.0)
        }

        user.signUpInBackground { suc, error in
            let id = user.objectId
            callback(suc, error, id!)
        }
    }

    // 把事件添加到user上
    func addEventToUser(_ e: Event, listName: String, needUploadAndCallback: ((Bool, Error?) -> Void)?) {
        guard let user = AVUser.current() else {
            return
        }

        let value = DataTools.checkValue(e)
        user.add(value, forKey: listName)

        if needUploadAndCallback == nil {
            return
        }

        let opt = AVSaveOption()
        opt.fetchWhenSave = true
        user.saveInBackground(with: opt, block: { suc, error in
            needUploadAndCallback!(suc, error)
        })
    }

//    func updateUser() {
//
//        guard let user = AVUser.current() else {
//            return
//        }
//
//        let userQuery = AVQuery(className: "_User")
//
//        userQuery.includeKey("active")
//
//        userQuery.getObjectInBackground(withId: user.objectId!) { obj, error in
//            let e = obj?["active"]
//            if e is [AVObject] {
//                let elist = (e as! [AVObject])
//                for ee in elist {
//                    print(ee.objectId ?? "nono")
//                }
//                let e1 = elist[0]
//                let n = e1["mc1"] as? Int
//                print(n ?? "no n")
//            }
//
//            self.abc()
//        }
//    }
//
//    func abc() {
//        guard let user = AVUser.current() else {
//            return
//        }
//
//        print(user.sessionToken ?? "no")
//
//        let eventList = [
//            AVObject(className: "event", objectId: "5875f4d1ac502e006c38f5b3"),
//            AVObject(className: "event", objectId: "5875f4d1ac502e006c38f5b3"),
//            AVObject(className: "event", objectId: "5875f4d1ac502e006c38f5b3"),
//            AVObject(className: "event", objectId: "5875f376ac502e006c38eb42")
//        ]
//        user.setObject(175, forKey: "ttt")
//        user.setObject(eventList, forKey: "active")
//
//        let opt = AVSaveOption()
//        opt.fetchWhenSave = true
//        user.saveInBackground(with: opt, block: { suc, error in
//            print(suc, error?.localizedDescription ?? "??")
//
//            let e = user["active"]
//            if e is [AVObject] {
//                let e1 = (e as! [AVObject])[0]
//                let n = e1["mc1"] as? Int
//                print(n ?? "no n")
//            }
//            print(user["ttt"] as! Int)
//        })
//    }

    // 对象 --------------------------------------------------------------------

    // 创建对象
    func createObj(to list: String, attris: [(String, Any)], callback: @escaping ((Bool, Error?, String) -> Void)) {
        let todo = AVObject(className:  list)
        for attri in attris {
            let value = DataTools.checkValue(attri.1)
            todo.setObject(value, forKey: attri.0)
        }

        todo.saveInBackground { suc, error in
            callback(suc, error, todo.objectId!)
        }
    }
}
