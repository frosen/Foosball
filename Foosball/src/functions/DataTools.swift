//
//  DataTools.swift
//  Foosball
//
//  Created by luleyan on 2017/1/13.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import Foundation

class DataTools: NSObject {
    class Promises {
        class func serialize(_ promises: [Promise]) -> [String] {
            var list: [String] = []
            for promise in promises {
                list.append(promise.toString)
                list.append(promise.toString)
                list.append(promise.toString)
            }
            return list
        }

        class func unserialize(_ list: [String]) -> [Promise] {
            return []
        }
    }

    // -------------------------------------------------------

    class UserStates {
        class func serialize(_ userStates: [UserState]) -> [[String: Any]] {
            var list: [[String: Any]] = []
            for userState in userStates {
                list.append(serializeOne(userState))
            }

            return list
        }

        class func serializeOne(_ userState: UserState) -> [String: Any] {
            return [
                "id": userState.user.ID.rawValue,
                "st": userState.state.rawValue
            ]
        }

        class func unserialize(_ list: [[String: Any]]) -> [UserState] {
            var users: [UserState] = []
            for map in list {
                let user = User(ID: DataID(ID: map["id"] as! DataID.IDType)) // 先暂时都是用新建的user
                let st = EventState(rawValue: map["st"] as! Int)!
                let ust = UserState(user: user, state: st)
                users.append(ust)
            }

            return users
        }
    }

    // -------------------------------------------------------
}









