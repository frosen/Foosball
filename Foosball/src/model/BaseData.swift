//
//  BaseData.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

//辨识所有结构体的标志，由服务器产生，可轻松从服务器中查找
class DataID: Hashable {
    let ID: Int //这个值用于在服务器快速查找该数据的位置

    init(ID: Int) {
        self.ID = ID
    }

    var hashValue: Int {
        return ID
    }
}

func ==(lhs: DataID, rhs: DataID) -> Bool {
    return lhs.ID == rhs.ID
}

//对时间表示的封装 ----------------------------------------------------------------------------

class Time {
    let time: Date

    //以当前时间初始化
    init(t: Date) {
        self.time = t
    }

    init(timeIntervalSinceNow: TimeInterval) {
        self.time = Date(timeIntervalSinceNow: timeIntervalSinceNow)
    }

    //获取当前时间的Time
    static var now: Time {
        return Time(t: Date())
    }

    //根据当前时间获取不同的时间文本
    var toString: String {
        let now = Date()
        let interval: TimeInterval = now.timeIntervalSince(time)

        var timeStr: String
        if interval < 60 {
            timeStr = "刚刚"
        } else if interval < 3600 {
            let min = floor(interval / 60)
            timeStr = String(Int(min)) + "分钟前"
        } else {
            let calendar = Calendar.current
            let dateCom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: time)
            let nowCom = calendar.dateComponents([.year, .month, .day], from: time)

            if dateCom.year! * 10000 + dateCom.month! * 100 + dateCom.day! < nowCom.year! * 10000 + nowCom.month! * 100 + nowCom.day! {
                timeStr = String(dateCom.month!) + "月" + String(dateCom.day!) + "日"
            } else {
                timeStr = String(dateCom.hour!) + ":" + String(format: "%02d", dateCom.minute!)
            }
        }

        print(timeStr)

        return timeStr
    }

    var toWholeString: String {
        let com = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: time)
        return String(com.month!) + "月" + String(com.day!) + "日 " +
            String(com.hour!) + ":" + String(format: "%02d", com.minute!)
    }

    var toLeftHourSineNow: Int {
        return Int(floor(time.timeIntervalSinceNow / 3600))
    }
}

func ==(lhs: Time, rhs: Time) -> Bool {
    return lhs.time == rhs.time
}

func <(lhs: Time, rhs: Time) -> Bool {
    return lhs.time < rhs.time
}


//位置信息的封装 ----------------------------------------------------------------------------

// 用于获取当前位置
class LocationMgr: NSObject, AMapLocationManagerDelegate {

    fileprivate static let shareInstance = LocationMgr()
    private var isSearching: Bool = false

    // loc ------------------------------------------------------------------------------
    private var mgr: AMapLocationManager? = nil

    var callForLoc: ((Bool, CLLocation?, String?) -> Void)? = nil
    func getCurLoc(callback: @escaping (Bool, CLLocation?, String?) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            callback(false, nil, nil)
            return
        }

        callForLoc = callback

        if isSearching == true {
            print("isSearching")
            return
        }
        isSearching = true

        if mgr == nil {
            mgr = AMapLocationManager()
            mgr!.delegate = self
        }
        mgr!.startUpdatingLocation()
    }

    // CLLocationManagerDelegate

    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        guard location != nil && reGeocode != nil else {
            manager.stopUpdatingLocation()
            return
        }

        print("didUpdateLocations", location.coordinate, reGeocode)
        isSearching = false

        let str = reGeocode.formattedAddress

        if let callback = callForLoc {
            callback(true, location, str)
        }
        manager.stopUpdatingLocation()
        callForLoc = nil
    }

    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        print("ERROR: locationManager", error)
        isSearching = false
        if let callback = callForLoc {
            callback(false, nil, nil)
        }
    }
}

class Location: NSObject, AMapSearchDelegate {
    // 可空，空就是位置待定
    var loc: CLLocation? = nil
    var locString: String? = nil

    init (l: CLLocation? = nil) {
        self.loc = l
    }

    // 回调：位置，位置文本，是否成功
    func fetchCurLoc(callback: @escaping ((CLLocation?, String?, Bool) -> Void)) {
        LocationMgr.shareInstance.getCurLoc() { suc, loc, address in
            self.loc = loc
            self.locString = address
            callback(loc, address, suc)
        }
    }

    func getLoc(callback: @escaping ((CLLocation?) -> Void)) {
        if let l = loc {
            callback(l)
        } else {
            fetchCurLoc { loc, str, suc in
                callback(suc ? loc : nil)
            }
        }
    }

    func getAddress(callback: @escaping ((String?) -> Void)) {
        if let ad = locString {
            callback(ad)
        } else {
            fetchCurLoc { loc, str, suc in
                callback(suc ? str : nil)
            }
        }
    }
}

//基础数据 ----------------------------------------------------------------------------

class BaseData: NSObject {
    let ID: DataID //本结构体的id
    init(ID: DataID) {
        self.ID = ID
    }
}
