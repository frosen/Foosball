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

    // 创建对象
    func createObj(to list: String, attris: [(String, Any)], callback: @escaping ((Bool, Error?) -> Void)) {
        let todo = AVObject(className:  list)
        for attri in attris {
            let value = checkValue(attri.1)
            todo.setObject(value, forKey: attri.0)
        }

        todo.saveInBackground { suc, error in
            callback(suc, error)
        }
    }

    private func checkValue(_ v: Any) -> Any {
        if v is CLLocation {
            return AVGeoPoint(location: v as! CLLocation)
        }

        return v
    }

//    //创建或者更新一场比赛
//    func updateMatch(match: MatchInfo, callback: (_ suc: Bool, _ e: NSError?) -> Void) {
//        print("create match")
//
//        let obj = AVObject(className: OBJ_NAME)
//
//        if match.id != "" {
//            obj.objectId = match.id
//        }
//
//        obj.setObject(match.matchName, forKey: "matchName")
//        obj.setObject(match.teamNameArray, forKey: "teamNameArray")
//        obj.setObject(match.remarks, forKey: "remarks")
//        obj.setObject(match.inningNum, forKey: "inningNum")
//        obj.setObject(match.scoreList, forKey: "scoreList")
//        obj.setObject(match.hasRewarded, forKey: "hasRewarded")
//
//        let option = AVSaveOption()
//        option.fetchWhenSave = true
//
//        obj.saveInBackgroundWithOption(option, block: callback)
//    }
//
//    //获取信息
//    func getMatch(id: String) -> MatchInfo {
//        let q = AVQuery(className: OBJ_NAME)
//        let obj = q.getObjectWithId(id)
//        return createMatchFromObj(obj)
//    }
//
//    //获取比赛信息表
//    func getMatchList(callback: (_ suc: Bool, _ list: [MatchInfo]) -> Void) {
//        let q = AVQuery(className: OBJ_NAME)
//        let objList = q.findObjects()
//
//        AVObject.fetchAllIfNeededInBackground(objList, block: {list, e in
//            if list == nil {
//                callback(suc: false, list: [])
//                return
//            }
//
//            let objList = list as! [AVObject]
//            var matchList: [MatchInfo] = []
//
//            for obj in objList {
//                matchList.append(self.createMatchFromObj(obj))
//            }
//
//            callback(suc: true, list: matchList)
//        })
//
//    }
//
//    private func createMatchFromObj(obj: AVObject) -> MatchInfo {
//        let match = MatchInfo()
//        match.id = obj.objectId as String
//        match.matchName = obj.objectForKey("matchName") as! String
//        match.teamNameArray = obj.objectForKey("teamNameArray") as! [String]
//        match.remarks = obj.objectForKey("remarks") as! String
//        match.inningNum = obj.objectForKey("inningNum") as! Int
//        match.scoreList = obj.objectForKey("scoreList") as! [[Int]]
//        match.hasRewarded = obj.objectForKey("hasRewarded") as! Bool
//        match.createTime = obj.createdAt
//        return match
//    }
}
