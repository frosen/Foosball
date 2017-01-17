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
    class Wagers {
        class func serialize(_ wagers: [Wager]) -> [String] {
            var list: [String] = []
            for wager in wagers {
                list.append(wager.toString)
                list.append(wager.toString)
                list.append(wager.toString)
            }
            return list
        }

        class func unserialize(_ list: [String]) -> [Wager] {
            return []
        }
    }

    // -------------------------------------------------------

    class UserStates {
        class func serialize(_ userStates: [UserState]) -> [[String: Any]] {
            var list: [[String: Any]] = []
            for userState in userStates {
                list.append([
                    "id": userState.user.ID.rawValue,
                    "st": userState.state.rawValue
                    ])
            }

            return list
        }

        class func unserialize(_ list: [[String: Any]]) -> [UserState] {
            return []
        }
    }

    // -------------------------------------------------------

    class DataIDs {
        class func serialize(_ ids: [DataID]) -> [String] {
            var list: [String] = []
            for id in ids {
                list.append(id.rawValue)
            }

            return list
        }

        class func unserialize(_ list: [String]) -> [DataID] {
            var ids: [DataID] = []
            for str in list {
                ids.append(DataID(ID: str))
            }
            return ids
        }

    }

    // -------------------------------------------------------

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
