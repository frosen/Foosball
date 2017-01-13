//
//  DataTools.swift
//  Foosball
//
//  Created by luleyan on 2017/1/13.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import Foundation
import AVOSCloud

class DataTools: NSObject {
    class func serialize(wagers: [(Int, Int, Int)]) -> [Int] {
        var list: [Int] = []
        for wager in wagers {
            list.append(wager.0)
            list.append(wager.1)
            list.append(wager.2)
        }
        return list
    }

    class func unserialize_wagers(from list: [Int]) -> [(Int, Int, Int)] {
        return []
    }

    // -------------------------------------------------------

    class func serialize(userStates: [UserState]) -> [[String: Any]] {
        var list: [[String: Any]] = []
        for userState in userStates {
            list.append([
                "id": userState.user.ID.rawValue,
                "st": userState.state.rawValue
                ])
        }

        return list
    }

    // -----

    class func checkValue(_ v: Any) -> Any {
        if v is CLLocation {
            return AVGeoPoint(location: v as! CLLocation)
        }

        switch v {
        case is CLLocation:
            return AVGeoPoint(location: v as! CLLocation)
        case is Event:
            return AVObject(className: Event.classname, objectId: (v as! Event).ID.rawValue)
        default:
            return v
        }
    }
}
