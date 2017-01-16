//
//  UserMgr.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/11/5.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol UserMgrObserver {
    func onInit(user: User)
    func onModify(user: User)
}

class UserMgr: DataMgr<User, UserMgrObserver> {

    enum LoginState: Int {
        case no
        case device
        case user
    }

    override init() {
        super.init()
        print("初始化 UserMgr")

        // 读取本地登录数据
        if getLoginState() == .no {
            registerDeviceLogin()

        } else {
            readLocalUserData()
            gotoScanServerData()
        }
    }

    func getLoginState() -> LoginState {
        let hasCurUser = Network.shareInstance.hasCurUser()
        if !hasCurUser {
            return .no
        }
        return .device
    }

    // 用户未登录前，直接用设备id注册一个用户
    func registerDeviceLogin() {
        var loginName: String = ""
        for _ in 0 ..< 5 { // 前5位可能会显示到昵称里，所以都是大写英文
            loginName += String(format: "%c", arc4random_uniform(91 - 65) + 65)
        }
        for _ in 0 ..< 15 {
            loginName += String(format: "%c", arc4random_uniform(123 - 48) + 48)
        }

        // 截出前几位，用于昵称中
        let index = loginName.index(loginName.startIndex, offsetBy: 4)
        let subStr = loginName.substring(to: index)

        var password: String = ""
        for _ in 0 ..< 8 { // 前5位可能会显示到昵称里，所以都是大写英文
            password += String(format: "%c", arc4random_uniform(123 - 48) + 48)
        }

        data = User(ID: DataID(ID: "no register"))
        data.name = "苹果玩家" + subStr
        data.avatarURL = ""

        let attris: [(String, Any)] = [
            ("nick", data.name),
            ("url", data.avatarURL),
            ("isR", data.isRegistered),
        ]

        Network.shareInstance.registerUser(id: loginName, pw: password, attris: attris) { suc, error, newID in
            guard suc else {
                return
            }

            self.data.ID = DataID(ID: newID)

            self.gotoScanServerData()
        }
    }

    func readLocalUserData() {
        guard let attris = Network.shareInstance.getUserAttris(attriNames: ["nick", "url", "isR"]) else {
            print("ERROR: no attris")
            return
        }
        
        data = User(ID: DataID(ID: attris["id"] as! String))
        data.name = attris["nick"] as! String
        data.avatarURL = attris["url"] as! String
        data.isRegistered = attris["isR"] as! Bool
    }

    // 开启轮询
    func gotoScanServerData() {
//        Network.shareInstance.updateUser()
    }

    // ---------------------------------------------------------------------------

    override func initObserver(_ ob: UserMgrObserver) {
        ob.onInit(user: data)
    }

    override func modifyObserver(_ ob: UserMgrObserver) {
        ob.onModify(user: data)
    }

    // ---------------------------------------------------------------------------

    // 同时给活动事件和所有事件
    func addNewEvent(_ e: Event, callback: @escaping ((Bool, Error?) -> Void)) {
        Network.shareInstance.addEventToUser(e, listName: "active", needUploadAndCallback: nil)
        Network.shareInstance.addEventToUser(e, listName: "events", needUploadAndCallback: callback)
    }

    // 工具 -----------------------------------------------------------------------
    func getState(from event: Event, by id: DataID) -> EventState {
        var s = searchSelfState(from: event, by: id)

        // todo 如果是胜利和失败，根据其他人的状态，自己显示不同的状态
        if s == .win || s == .lose {
            
        }

        return s
    }

    private func searchSelfState(from event: Event, by id: DataID) -> EventState {
        for us in event.ourSideStateList {
            if us.user.ID == id {
                return us.state
            }
        }
        for us in event.opponentStateList {
            if us.user.ID == id {
                return us.state
            }
        }

        print("wrong in searchState")
        return .finish
    }
}




