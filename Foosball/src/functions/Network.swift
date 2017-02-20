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
            callback(suc, error, id ?? "")
        }
    }

    func getUserAttris() -> Any? {
        return AVUser.current()
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

    // 获取 orderType: 0无顺序，1时间从早到晚，2时间从晚到早
    func fetchObjs(from: String, ids: [String], with lists: [String], orderType: Int, callback: @escaping ((Bool, Any?) -> Void)) {
        let query = AVQuery(className: from)
        query.whereKey("objectId", containedIn: ids)

        for list in lists {
            query.includeKey(list)
        }

        if orderType == 1 {
            query.order(byAscending: "updatedAt") // 早的在前
        } else if orderType == 2 {
            query.order(byDescending: "updatedAt") // 早的在后
        }

        query.findObjectsInBackground { objs, error in
            if error != nil || objs == nil {
                return callback(false, nil)
            }
            print("fetch \(from) suc")
            callback(true, objs)
        }
    }

    // 给某个列表的属性添加或者删除值
    func updateObj(to classname: String, id: String, changeAttris: [String: Any], addAttris: [String: Any], removeAttris: [String: Any], callback: @escaping ((Bool, Error?) -> Void)) {
        let todo = AVObject(className: classname, objectId: id)

        for attri in addAttris {
            let value = checkValue(attri.value)
            todo.add(value, forKey: attri.key)
        }

        for attri in removeAttris {
            let value = checkValue(attri.value)
            todo.remove(value, forKey: attri.key)
        }

        for attri in changeAttris {
            let value = checkValue(attri.value)
            todo.setObject(value, forKey: attri.0)
        }

        let opt = AVSaveOption()
        opt.fetchWhenSave = true
        todo.saveInBackground(with: opt) { suc, error in
            callback(suc, error)
        }
    }

    // 查询数量
    func queryCount(to list: String, attris: [(String, String)], callback: @escaping ((Int, Error?) -> Void)) {
        var querys: [AVQuery] = []
        print(attris)
        for attri in attris {
            let q = AVQuery(className: list)
            q.whereKey(attri.0, contains: attri.1)
            querys.append(q)
        }

        let query = AVQuery.orQuery(withSubqueries: querys)
        query.countObjectsInBackground { num, error in
            callback(num, error)
        }
    }

    // 云函数 -------------------------------------------------------------------

    func create(className: String, attris: [String: Any], AndAddTo classForAdd: String, id: String, keyDict: [String: Int],  callback: @escaping ((Bool, Error?) -> Void)) {

        var handledAttris: [String: Any] = [:]
        for attri in attris {
            let value = checkValue(attri.value)
            handledAttris[attri.key] = value
        }

        var params: [String: Any] = [:]
        params["cls"] = className
        params["params"] = handledAttris
        params["clsadd"] = classForAdd
        params["idadd"] = id
        params["keys"] = keyDict

        AVCloud.callFunction(inBackground: "createObjAndAddToList", withParameters: params) { obj, error in
            callback(error == nil, error)
        }
    }

    func removeMultipleData(classNames: [String], ids: [String], rms: [[String: Any]], callback: @escaping ((Bool, Error?) -> Void)) {
        var params: [String: Any] = [:]
        params["clss"] = classNames
        params["ids"] = ids

        var handledRms: [[String: Any]] = []
        for rm in rms {
            var handledRm: [String: Any] = [:]
            for tup in rm {
                let value = checkValue(tup.value)
                handledRm[tup.key] = value
            }
            handledRms.append(handledRm)
        }
        params["rms"] = handledRms

        AVCloud.callFunction(inBackground: "removeMultipleData", withParameters: params) { obj, error in
            callback(error == nil, error)
        }
    }

    // 解析 -------------------------------------------------------------------

    // 参数必须是AVObject，为了不对外开放，所以对外为NSObject
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





