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
class LocationMgr: NSObject, CLLocationManagerDelegate {

    fileprivate static let shareInstance = LocationMgr()
    var call: ((CLLocation?) -> Void)? = nil

    private var mgr: CLLocationManager {
        let m = CLLocationManager()
        m.delegate = self
        return m
    }

    func getCurLoc(callback: @escaping (CLLocation?) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            callback(nil)
            return
        }

        call = callback
        mgr.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let callback = call {
            callback(locations[0])
        }
        manager.stopUpdatingLocation()
        call = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

class Location {
    // 可空，空就是位置待定
    var loc: CLLocation? = nil

    init (l: CLLocation? = nil) {
        self.loc = l
    }

    func getCurLoc() {
        LocationMgr.shareInstance.getCurLoc() { loc in
            self.loc = loc
        }
    }

    var toString: String {
        return "北京市朝阳区三里屯南里源泉花园小区15号楼8单元1415号"
    }
}

//基础数据 ----------------------------------------------------------------------------

class BaseData: NSObject {
    let ID: DataID //本结构体的id
    init(ID: DataID) {
        self.ID = ID
    }
}
