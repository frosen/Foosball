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
                    "nick": userState.user.name,
                    "url": userState.user.avatarURL,
                    "st": userState.state.rawValue
                    ])
            }

            return list
        }

        class func unserialize(_ list: [[String: Any]]) -> [UserState] {
            var users: [UserState] = []
            for map in list {
                let ubr = UserBrief(
                    ID: DataID(ID: map["id"] as! DataID.IDType),
                    name: map["nick"] as! String,
                    url: map["url"] as! String
                )
                let st = EventState(rawValue: map["st"] as! Int)!
                let ust = UserState(user: ubr, state: st)
                users.append(ust)
            }
            return users
        }
    }

    // -------------------------------------------------------
}
