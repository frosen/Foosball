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
            updateUser() // 立即更新
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

        let attris: [(String, Any)] = [
            ("nick", data.name),
            ("url", data.avatarURL),
            ("isR", data.isRegistered),
        ]

        Network.shareInstance.registerUser(id: loginName, pw: password, attris: attris) { suc, error, newID in
            guard suc else {
                print("ERROR: registerUser in registerDeviceLogin", error ?? "no error")
                self.registerDeviceLogin() // 尝试重新注册
                return
            }

            self.data.ID = DataID(ID: newID)

            self.updateObserver()
            self.saveData()
            self.gotoScanServerData()
        }
    }

    func readLocalUserData() {
        var attris: [String: Any] = [
            "id": "id",
            "nick": "name",
            "url": "url",
            "isR": false,
        ]

        Network.shareInstance.getUserAttris(into: &attris) { str, attris in
            guard str != nil else {
                print("ERROR: no attris in readLocalUserData")
                return
            }

            resetData(attris)
        }
    }

    // 开启轮询
    func gotoScanServerData() {
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(UserMgr.timer), userInfo: nil, repeats: true)
    }

    func timer(_ t: Timer) {
        updateUser()
    }

    var attrisKeeper: [String: Any] = [
        "id": "id",
        "nick": "name",
        "url": "url",
        "isR": false,
        "active": [["eventAttriName": "eventAttri"]]
    ]

    func updateUser() {
        Network.shareInstance.updateUser(
            into: &attrisKeeper,
            with: ["avtive"]
        ) { str, attris in
            if str == nil {
                print("ERROR: no attris in gotoScanServerData")

            } else if str == "suc" {
                // 成功后要刷新events表，所以先清空
                APP.activeEventsMgr.cleanData()

            } else if str == "active" {
                APP.activeEventsMgr.addNewData(attris)

            } else if str == "" {
                self.resetData(attris)

                self.updateObserver()
                self.saveData()

                APP.activeEventsMgr.updateObserver()
                APP.activeEventsMgr.saveData()
            }
        }
    }

    func resetData(_ attris: [String: Any]) {
        if data == nil {
            data = User(ID: DataID(ID: attris["id"] as! String))
        } else {
            data.ID = DataID(ID: attris["id"] as! String)
        }

        data.name = attris["nick"] as! String
        data.avatarURL = attris["url"] as! String
        data.isRegistered = attris["isR"] as! Bool
    }

    func addActiveEvents(_ attris: [String: Any]) {

    }

    // ---------------------------------------------------------------------------

    override func saveData(needUpload: Bool = false) {
        // 用户数据不需要自己进行本地保存，会保存到leancloud中

        if needUpload {
            
        }
    }

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




