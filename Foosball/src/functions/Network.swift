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

    // 因为User有特殊的list，所以单独做一个函数
    func getUserAttris(into attris: inout [String: Any], callback: ((String?, [String: Any]) -> Void)) {
        guard let user = AVUser.current() else {
            callback(nil, [:])
            return
        }
        parse(obj: user, by: &attris, callback: callback, key: "")
    }

    func updateUser(into attris: inout [String: Any], with lists: [String], callback: @escaping ((String?, [String: Any]) -> Void)) {
        guard let user = AVUser.current() else {
            return
        }

        let userQuery = AVQuery(className: "_User")

        for list in lists {
            userQuery.includeKey(list)
        }

        var holdAttris = attris
        userQuery.getObjectInBackground(withId: user.objectId!) { obj, error in
            if error != nil || obj == nil {
                callback(nil, [:])
                return
            }
            callback("suc", [:])
            self.parse(obj: obj!, by: &holdAttris, callback: callback, key: "")
        }
    }

    // 参数必须是AVObject，为了不对外开放，所以对外为NSObject
    // inout: 参考 http://blog.csdn.net/chenyufeng1991/article/details/48495367
    func parse(obj: NSObject, by attris: inout [String: Any], callback: ((String?, [String: Any]) -> Void), key: String) {
        guard let avobj = obj as? AVObject else {
            print("ERROR: obj is not AVObj")
            callback(nil, [:])
            return
        }

        for attri in attris {
            let name = attri.key
            guard let value = avobj[name] else {
                if name == "id" { // 特殊字段
                    attris[name] = avobj.objectId
                } else {
                    print("ERROR: no name \(name) in obj")
                }
                continue
            }

            if value is AVObject && attri.value is [String: Any] {
                var subAttri: [String: Any] = attri.value as! [String : Any]
                parse(obj: value as! AVObject, by: &subAttri, callback: callback, key: name)

            } else if value is [AVObject] && attri.value is [[String: Any]] {
                let valueList = value as! [AVObject]
                var attriDict = attri.value as! [[String: Any]]
                var subAttri: [String: Any] = attriDict[0]
                for v in valueList {
                    parse(obj: v, by: &subAttri, callback: callback, key: name)
                    attriDict.append(subAttri)
                }
            } else {
                attris[name] = value
            }
        }

        callback(key, attris)
    }

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





