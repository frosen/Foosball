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

    static var attrisKeeper: [String: Any] = [
        "id": "id",
        "nick": "name",
        "sign": "sign",
        "url": "url",
        "sex": 0,
        "isR": false,
    ]

    class func copyAttrisKeeper() -> [String: Any] {
        var keeper: [String: Any] = [:]
        for attri in UserMgr.attrisKeeper {
            keeper[attri.key] = attri.value
        }
        return keeper
    }

    // 复制一个user的attrisKeeper，并且其中有个属性为active，里面是event的attrisKeeper的list
    class func createAttrisKeeperWithActive() -> [String: Any] {
        var keeper = copyAttrisKeeper()

        var active: [String: Any] = [:]
        for tup in ActiveEventsMgr.attrisKeeper {
            active[tup.key] = tup.value
        }

        keeper["active"] = [active]

        return keeper
    }

    // ------------------------------------------------------

    override init() {
        super.init()
        print("初始化 UserMgr")

        data = []
        loadFromLocal()
    }

    func run() {
        // 读取本地登录数据
        if getLoginState() == .no {
            registerDeviceLogin()

        } else {
            perform(#selector(UserMgr.fetchMeAtOnce), with: nil, afterDelay: 1.0) // 1秒后立即更新
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

        // 随机一个用户名和密码
        var loginName: String = ""
        for _ in 0 ..< 5 { // 前5位可能会显示到昵称里，所以都是大写英文
            loginName += String(format: "%c", arc4random_uniform(91 - 65) + 65)
        }
        for _ in 0 ..< 15 {
            loginName += String(format: "%c", arc4random_uniform(123 - 48) + 48)
        }

        var password: String = ""
        for _ in 0 ..< 8 {
            password += String(format: "%c", arc4random_uniform(123 - 48) + 48)
        }

        // 截出前几位，用于昵称中
        let index = loginName.index(loginName.startIndex, offsetBy: 4)
        let subStr = loginName.substring(to: index)

        // 创建数据
        let me = User(ID: DataID(ID: "no register"))
        me.name = "苹果玩家" + subStr

        let attris: [String: Any] = [
            "nick": me.name,
            "sign": me.sign,
            "url": me.avatarURL,
            "sex": me.sex,
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
            self.saveToLocal()
            self.gotoScanServerData()
        }
    }

    // 开启轮询 --------------------------------------------------------------------------

    private func gotoScanServerData() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UserMgr.timer), userInfo: nil, repeats: true)
    }

    private static let scanSecondMax: Int = 15
    private var scanSecond: Int = scanSecondMax

    func timer(_ t: Timer) {
        scanSecond -= 1
        if scanSecond <= 0 {
            fetchMeAtOnce()
        }
    }

    func fetchMeAtOnce() {
//        fetchMe()
        scanSecond = UserMgr.scanSecondMax
    }

    private func fetchMe() {
        Network.shareInstance.fetchObjs(from: User.classname, ids: [data[0].ID.rawValue], with: ["active"], orderType: 0) { suc, objs in
            if !suc {
                print("ERROR: no attris in fetchMe")
                APP.errorMgr.hasError()
                return
            }

            DispatchQueue(label: self.parseThreadName).async {

                var keeper = UserMgr.createAttrisKeeperWithActive() // 创建一个属性持有器
                var newEventList: [Event] = []

                Network.shareInstance.parse(obj: objs!, by: &keeper) { str, attris in
                    if str == "active" {
                        let e = ActiveEventsMgr.createNewEvent(attris)
                        newEventList.append(e)
                    }
                }

                // 在本地进行数据处理
                ActiveEventsMgr.sort(newEventList)

                // 查询未fetch的user数据
                var needFetchUserList: [User] = []
                UserMgr.checkUnfetchUsers(from: newEventList, by: self.data!, needFetchUserList: &needFetchUserList)

                let newChange = ActiveEventsMgr.checkNewEventChangeMap(
                    newEvents: newEventList,
                    oldChangeMap: APP.activeEventsMgr.eventChangeMap,
                    user: self.me
                )

                DispatchQueue.main.async {
                    self.resetMe(keeper)
                    self.saveToLocal()

                    self.updateObserver()

                    APP.activeEventsMgr.updateData(newEventList)
                    APP.activeEventsMgr.saveChange(newChange)
                    APP.activeEventsMgr.saveToLocal()

                    if needFetchUserList.count > 0 {
                        self.fetchUnfetchUsers(needFetchUserList) { suc in
                            if suc {
                                APP.activeEventsMgr.updateObserver()
                            } else {
                                APP.errorMgr.hasError()
                            }
                        }
                    } else {
                        APP.activeEventsMgr.updateObserver()
                    }
                }
            }
        }
    }

    func resetMe(_ attris: [String: Any]) {
        if data.count == 0 { // 列表中第一个就是自己
            data.append(User(ID: DataID(ID: "reset")))
        }
        UserMgr.reset(user: &data[0], attris: attris)
    }

    class func reset(user: inout User, attris: [String: Any]) {
        user.ID = DataID(ID: attris["id"] as! String)
        user.name = attris["nick"] as! String
        user.sign = attris["sign"] as! String
        user.avatarURL = attris["url"] as! String
        user.sex = attris["sex"] as! Int
        user.isRegistered = attris["isR"] as! Bool
    }

    // 判断一个event list里面的所有user是否是下载过的，是则指向已经下载的，不是则放入“需下载”列表
    class func checkUnfetchUsers(from newEventList: [Event], by oldUsers: [User], needFetchUserList: inout [User]) {
        for e in newEventList {
            let _ = e.eachUserState { newUserSt in
                var isNew = true
                for oldUser in oldUsers {
                    if newUserSt.user.ID == oldUser.ID {
                        newUserSt.user = oldUser
                        isNew = false
                        break
                    }
                }
                if isNew {
                    needFetchUserList.append(newUserSt.user)
                }
                return false
            }
        }
    }

    // 获取未获取的用户数据 -------------------------------------------------------------------

    func fetchUnfetchUsers(_ unfetchUserList: [User], callback: @escaping ((Bool) -> Void)) {

        var ids: [String] = []
        for user in unfetchUserList {
            ids.append(user.ID.rawValue)
        }
        ids = Array(Set(ids)) // 转换成set，为了去除重复项

        Network.shareInstance.fetchObjs(from: User.classname, ids: ids, with: [], orderType: 0) { suc, objs in
            guard suc else {
                print("ERROR: no attris in updateMe")
                callback(false)
                return
            }
            
            DispatchQueue(label: self.parseThreadName).async {
                var keeper = UserMgr.copyAttrisKeeper()
                Network.shareInstance.parse(obj: objs!, by: &keeper, callback: { str, attris in
                    if str == "" {
                        UserMgr.resetUser(by: attris["id"] as! String, data: unfetchUserList, attris: attris)
                    }
                })
                DispatchQueue.main.async {
                    self.data.append(contentsOf: unfetchUserList)
                    callback(true)
                }
            }
        }
    }

    class func resetUser(by id: String, data: [User], attris: [String: Any]) {
        for user in data {
            if user.ID.rawValue == id {
                var u = user
                UserMgr.reset(user: &u, attris: attris)
            }
        }
    }

    // 继承 -------------------------------------------------------------------------------

    override func initObserver(_ ob: UserMgrObserver) {
        ob.onInit(user: data[0])
    }

    override func modifyObserver(_ ob: UserMgrObserver) {
        ob.onModify(user: data[0])
    }

    override func saveToLocal() {
        // 用户数据不需要自己进行本地保存，会保存到leancloud中
    }

    override func loadFromLocal() {
        // 个人信息的数据用Network储存到本地，所以从这里取
        let res: Any? = Network.shareInstance.getUserAttris()
        if res == nil {
            print("ERROR: wrong getUserAttris in readLocalUserData")
        } else {
            Network.shareInstance.parse(obj: res!, by: &UserMgr.attrisKeeper, callback: { _, _ in })
            resetMe(UserMgr.attrisKeeper)
        }
    }

    // 便捷函数 ----------------------------------------------------------------------------------

    var me: User {
        return data[0]
    }

    func getMeState(_ e: Event) -> EventState {
        return UserMgr.getState(from: e, by: me.ID)
    }

    // 根据整个事件获取某个id的状态
    class func getState(from event: Event, by id: DataID) -> EventState {
        let usTup = event.eachUserState { us in
            return us.user.ID == id
        }

        if usTup == nil {
            print("ERROR: wrong in searchState")
            return .watch
        }

        var s = usTup!.0.state

        // todo 如果是胜利和失败，根据其他人的状态，自己显示不同的状态
        if s == .win || s == .lose {
            
        }

        return s
    }
}




