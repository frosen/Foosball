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
        class func serialize(_ userStates: [UserState]) -> ([User], [Int]) {
            var listUser: [User] = []
            var listST: [Int] = []
            for userState in userStates {
                listUser.append(userState.user)
                listST.append(userState.state.rawValue)
            }

            return (listUser, listST)
        }

        class func unserialize(_ listUserAttri: [[String: Any]], st: [Int]) -> [UserState] {
            var users: [UserState] = []
            if listUserAttri.count != st.count {
                print("ERROR: UserStates unserialize listID.count != st.count")
                return []
            }

            for i in 0 ..< listUserAttri.count {
                var user = User(ID: DataID(ID: "us"))
                APP.userMgr.reset(user: &user, attris: listUserAttri[i])
                let st = EventState(rawValue: st[i])!
                let ust = UserState(user: user, state: st)
                users.append(ust)
            }
            return users
        }
    }

    // -------------------------------------------------------
}
