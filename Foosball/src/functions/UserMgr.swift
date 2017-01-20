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

class UserMgr: DataMgr<[User], UserMgrObserver> {

    enum LoginState: Int {
        case no
        case device
        case user
    }

    static var baseAttriKeeper: [String: Any] = [
        "id": "id",
        "nick": "name",
        "sign": "sign",
        "url": "url",
        "isR": false,
        ]

    static var attrisKeeper: [String: Any] = {
        var keeper: [String: Any] = [:]
        for attri in baseAttriKeeper {
            keeper[attri.key] = attri.value
        }
        keeper["active"] = [ActiveEventsMgr.attrisKeeper]
        return keeper
    }()

    override init() {
        super.init()
        print("初始化 UserMgr")

        data = []

        // 读取本地登录数据
        if getLoginState() == .no {
            registerDeviceLogin()

        } else {
            readLocalUserData()
            perform(#selector(UserMgr.updateMe), with: nil, afterDelay: 1.0) // 1秒后立即更新
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
        for _ in 0 ..< 8 {
            password += String(format: "%c", arc4random_uniform(123 - 48) + 48)
        }

        let me = User(ID: DataID(ID: "no register"))
        me.name = "苹果玩家" + subStr

        let attris: [String: Any] = [
            "nick": me.name,
            "sign": me.sign,
            "url": me.avatarURL,
            "isR": me.isRegistered,
        ]
        data.append(me)

        Network.shareInstance.registerUser(id: loginName, pw: password, attris: attris) { suc, error, newID in
            guard suc else {
                print("ERROR: registerUser in registerDeviceLogin", error ?? "no error")
                self.perform(#selector(UserMgr.registerDeviceLogin), with: nil, afterDelay: 3.0) // 3秒后尝试重新注册
                return
            }

            me.ID = DataID(ID: newID)

            self.updateObserver()
            self.saveData()
            self.gotoScanServerData()
        }
    }

    func readLocalUserData() {
        // 个人信息的数据用Network储存到本地，所以从这里取
        let res: [String: Any]? = Network.shareInstance.getUserAttris(into: &UserMgr.baseAttriKeeper)
        if res == nil {
            print("ERROR: wrong getUserAttris in readLocalUserData")
        } else {
            resetMe(res!)
        }
    }

    // 开启轮询 --------------------------------------------------------------

    private func gotoScanServerData() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UserMgr.timer), userInfo: nil, repeats: true)
    }

    private static let scanSecondMax: Int = 15
    private var scanSecond: Int = scanSecondMax
    private var isScanPause: Bool = false
    func timer(_ t: Timer) {
        if isScanPause {
            return
        }

        scanSecond -= 1
        if scanSecond <= 0 {
            updateMe()
            scanSecond = UserMgr.scanSecondMax
        }
    }

    private func pauseScan() {
        isScanPause = true
    }

    private func resumeScan() {
        isScanPause = false
    }

    func updateMe() {
//        pauseScan()
//
//        Network.shareInstance.updateMe(
//            into: &UserMgr.attrisKeeper,
//            with: ["active"]
//        ) { str, attris in
//            if str == nil {
//                print("ERROR: no attris in updateMe")
//                self.resumeScan()
//
//            } else if str == "suc" {
//                // 成功后要刷新events表，所以先清空
//                APP.activeEventsMgr.cleanData()
//                self.resumeScan()
//
//            } else if str == "active" {
//                APP.activeEventsMgr.addNewData(attris)
//
//            } else if str == "" {
//                self.resetMe(attris)
//
//            } else if str == "end" {
//                self.updateObserver()
//                self.saveData()
//
//                // 看有没有未获取数据的用户，没有就获取
//                if self.hasUnfetchUsers() {
//                    self.fetchUnfetchUsers { suc in
//                        APP.activeEventsMgr.updateObserver()
//                        APP.activeEventsMgr.saveData()
//                    }
//                } else {
//                    APP.activeEventsMgr.updateObserver()
//                    APP.activeEventsMgr.saveData()
//                }
//            }
//        }
    }

    func resetMe(_ attris: [String: Any]) {
        if data.count == 0 {
            data.append(User(ID: DataID(ID: "reset")))
        }
        reset(user: &data[0], attris: attris)
    }

    func reset(user: inout User, attris: [String: Any]) {
        user.ID = DataID(ID: attris["id"] as! String)
        user.name = attris["nick"] as! String
        user.sign = attris["sign"] as! String
        user.avatarURL = attris["url"] as! String
        user.isRegistered = attris["isR"] as! Bool
    }

    // -------------------------------------------------------------------------

    // 记录需要从服务器获取具体数据的用户
    var unfetchUserList: [User] = []

    // 根据id，获取记录在表中的用户数据，如果没有则添加一个，并把新添加的这个user记录为“需fetch”
    func getOrCreateUser(id: DataID.IDType) -> User {
        for user in data {
            if user.ID.rawValue == id {
                return user
            }
        }

        // 未找到已经存在的user
        let newUser = User(ID: DataID(ID: id))
        data.append(newUser)
        unfetchUserList.append(newUser)

        return newUser
    }

    func hasUnfetchUsers() -> Bool {
        return unfetchUserList.count > 0
    }

    func fetchUnfetchUsers(callback: @escaping ((Bool) -> Void)) {
        pauseScan()

        var ids: [String] = []
        for user in unfetchUserList {
            ids.append(user.ID.rawValue)
        }
        Network.shareInstance.updateUsers(ids, into: &UserMgr.baseAttriKeeper, with: []) { str, attris in
            if str == nil {
                print("ERROR: fetchUnfetchUsers wrong")
                self.resumeScan()
                callback(false)

            } else if str == "suc" {
                self.resumeScan()

            } else if str == "" {
                self.resetUser(by: attris["id"] as! String, attris: attris)

            } else if str == "end" {
                callback(true)
            }
        }
    }

    func resetUser(by id: String, attris: [String: Any]) {
        for user in data {
            if user.ID.rawValue == id {
                var u = user
                reset(user: &u, attris: attris)
            }
        }
    }

    var me: User {
        return data[0]
    }

    // ---------------------------------------------------------------------------

    override func saveData(needUpload: [String: String]? = nil) {
        // 用户数据不需要自己进行本地保存，会保存到leancloud中
        
        //上传网络
        saveToServer(needUpload)
    }

    override func initObserver(_ ob: UserMgrObserver) {
        ob.onInit(user: data[0])
    }

    override func modifyObserver(_ ob: UserMgrObserver) {
        ob.onModify(user: data[0])
    }

    // ---------------------------------------------------------------------------

    // 同时给活动事件和所有事件
    func addNewEvent(_ e: Event, callback: @escaping ((Bool, Error?) -> Void)) {
        pauseScan()
        Network.shareInstance.addDataToUser(e, listName: "active", needUploadAndCallback: nil)
        Network.shareInstance.addDataToUser(e.ID.rawValue, listName: "events") { suc, error in
            self.resumeScan()
            callback(suc, error)
        }
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

        print("ERROR: wrong in searchState")
        return .ready
    }
}




