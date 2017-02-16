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

        static let separater = "_"

        class func serialize(_ userStates: [UserState]) -> [String] {
            var list: [String] = []
            for userState in userStates {
                list.append(serializeOne(userState))
            }
            return list
        }

        class func serializeOne(_ userState: UserState) -> String {
            let str = String(userState.user.ID.rawValue) + separater + String(userState.state.rawValue)
            return str
        }

        class func unserialize(_ list: [String]) -> [UserState] {
            var users: [UserState] = []
            for str in list {
                let strs = str.components(separatedBy: separater)
                let user = User(ID: DataID(ID: strs[0])) // 先暂时都是用新建的user
                let st = EventState(rawValue: Int(strs[1]) ?? -1) ?? .watch
                let ust = UserState(user: user, state: st)
                users.append(ust)
            }

            return users
        }
    }

    // -------------------------------------------------------
}









