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
//        AVOSCloud.setAllLogsEnabled(false)
        AVOSCloud.setApplicationId("o5nq2XE8H5XUlo9S94F9tioJ-gzGzoHsz", clientKey: "vJrjiBn25QQ4FmvIKhVx8bQ2")
    }

    // 用户相关 --------------------------------------------------------------------

    // 是否已经在本地保存了用户信息
    func hasCurUser() -> Bool {
//        AVUser.logOut()
        let curUser = AVUser.current()
        return curUser?.sessionToken != nil
    }

    func registerUser(id: String, pw: String, attris: [String: Any], callback: @escaping ((Bool, Error?, String) -> Void)) {
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

    func getUserAttris() -> Any? {
        return AVUser.current()
    }

    func fetchMe(with lists: [String], callback: @escaping ((Bool, Any?) -> Void)) {
        print("fetch me")
        guard let user = AVUser.current() else {
            return
        }
        fetchUsers([user.objectId!], with: lists, callback: callback)
    }

    func fetchUsers(_ ids: [String], with lists: [String], callback: @escaping ((Bool, Any?) -> Void)) {
        fetchObjs(from: User.classname, ids: ids, with: lists, callback: callback)
    }

    // 把事件添加到user上
    func addDataToUser(_ data: Any, listName: String, andUpdate: Bool, callback: ((Bool, Error?) -> Void)? = nil) {
        guard let user = AVUser.current() else {
            return
        }

        let value = checkValue(data)
        user.add(value, forKey: listName)

        if !andUpdate {
            return
        }

        let opt = AVSaveOption()
        opt.fetchWhenSave = true
        user.saveInBackground(with: opt, block: { suc, error in
            callback!(suc, error)
        })
    }

    func updateUser(_ attris: [String: Any], callback: @escaping ((Bool, Error?) -> Void)) {

    }

    // 对象 --------------------------------------------------------------------

    // 创建对象
    func createObj(to list: String, attris: [String: Any], callback: @escaping ((Bool, Error?, String?) -> Void)) {
        let todo = AVObject(className: list)
        for attri in attris {
            let value = checkValue(attri.value)
            todo.setObject(value, forKey: attri.0)
        }
        
        todo.saveInBackground { suc, error in
            callback(suc, error, todo.objectId)
        }
    }

    // 获取
    func fetchObjs(from: String, ids: [String], with lists: [String], callback: @escaping ((Bool, Any?) -> Void)) {
        let query = AVQuery(className: from)
        query.whereKey("objectId", containedIn: ids)

        for list in lists {
            query.includeKey(list)
        }

        query.findObjectsInBackground { objs, error in
            if error != nil || objs == nil {
                return callback(false, nil)
            }
            print("fetch \(from) suc")
            callback(true, objs)
        }
    }

    // 解析：参数必须是AVObject，为了不对外开放，所以对外为NSObject
    // inout: 参考 http://blog.csdn.net/chenyufeng1991/article/details/48495367
    func parse(obj: Any, by attris: inout [String: Any], callback: ((String?, [String: Any]) -> Void)) {
        if let avobjList = obj as? [AVObject] {
            for avobj in avobjList {
                parse(avobj: avobj, by: &attris, callback: callback, key: "")
            }
        } else if let avobj = obj as? AVObject {
            parse(avobj: avobj, by: &attris, callback: callback, key: "")
        } else {
            callback(nil, [:])
        }
    }

    private func parse(avobj: AVObject, by attris: inout [String: Any], callback: ((String?, [String: Any]) -> Void), key: String) {
        for attri in attris {
            let name = attri.key

            guard let value = avobj[name] else {
                if name == "id" { // 特殊字段
                    attris[name] = avobj.objectId
                } else {
                    print("ERROR: no name \(name) in obj [\(key)]")
                }
                continue
            }

            if value is AVGeoPoint {
                let geo = value as! AVGeoPoint
                attris[name] = CLLocation(latitude: geo.latitude, longitude: geo.longitude)

            } else if value is AVObject && attri.value is [String: Any] {
                var subAttri: [String: Any] = attri.value as! [String : Any]
                parse(avobj: value as! AVObject, by: &subAttri, callback: callback, key: name)

            } else if value is [AVObject] && (value as! [AVObject]).count > 0 && attri.value is [[String: Any]] {
                let valueList = value as! [AVObject]
                var attriDict = attri.value as! [[String: Any]]
                var subAttri: [String: Any] = attriDict[0]
                for v in valueList {
                    parse(avobj: v, by: &subAttri, callback: callback, key: name)
                    attriDict.append(subAttri)
                }
            } else {
                attris[name] = value
            }
        }
        
        callback(key, attris)
    }

    private func checkValue(_ v: Any) -> Any {
        switch v {
        case is CLLocation:
            return AVGeoPoint(location: v as! CLLocation)
        case is Event:
            return AVObject(className: Event.classname, objectId: (v as! Event).ID.rawValue)
        case is User:
            return AVObject(className: User.classname, objectId: (v as! User).ID.rawValue)
        case is [BaseData]:
            var arRes = [Any]()
            let arv = v as! [BaseData]
            if arv.count == 0 {
                return []
            } else {
                for vInAr in arv {
                    arRes.append(checkValue(vInAr))
                }
                return arRes
            }
        default:
            return v
        }
    }

    // 更新服务器
    func updateObj(from: String, id: String, attris: [String: Any], callback: @escaping ((Bool, Error?) -> Void)) {
        let todo = AVObject(className: from, objectId: id)
        for attri in attris {
            let value = checkValue(attri.value)
            todo.setObject(value, forKey: attri.0)
        }

        todo.saveInBackground { suc, error in
            callback(suc, error)
        }
    }

    // 上传文件 -----------------------------------------------------------------------------------

    func upload(data: Data, name: String, callback: @escaping ((String, Int) -> Void)) {
        let f = AVFile(name: name, data: data)
        f.saveInBackground({ (suc, error) in
            if !suc {
                print("ERROR: in upload", error ?? "no error")
                callback("fail", 0)
            } else {
                callback(f.url!, 0)
            }

        }) { progress in
            callback("p", progress)
        }
    }

    func getCutImgUrl(from str: String, by width: Int32) -> String? {
        let f = AVFile(url: str)
        let cutUrl = f.getThumbnailURLWithScale(toFit: true, width: width, height: width)
        return cutUrl
    }
}





