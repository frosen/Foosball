//
//  DataTools.swift
//  Foosball
//
//  Created by luleyan on 2017/1/13.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import Foundation

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

        class func unserialize(_ list: [[String: Any]], needFetchList: inout [User]) -> [UserState] {
            var users: [UserState] = []
            for map in list {
                let (user, needFetch) = APP.userMgr.getOrCreateUser(id: map["id"] as! DataID.IDType)
                let st = EventState(rawValue: map["st"] as! Int)!
                let ust = UserState(user: user, state: st)
                users.append(ust)
                if needFetch {
                    needFetchList.append(user)
                }
            }

            return users
        }
    }

    // -------------------------------------------------------
}









