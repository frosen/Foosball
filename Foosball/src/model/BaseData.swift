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
    typealias IDType = String
    fileprivate let ID: IDType //这个值用于在服务器快速查找该数据的位置

    init(ID: IDType) {
        self.ID = ID
    }

    var rawValue: IDType {
        return ID
    }

    var hashValue: Int {
        return ID.hashValue
    }
}

func ==(lhs: DataID, rhs: DataID) -> Bool {
    return lhs.ID == rhs.ID
}

func >(lhs: DataID, rhs: DataID) -> Bool {
    return lhs.ID > rhs.ID
}

//对时间表示的封装 ----------------------------------------------------------------------------

class Time {
    fileprivate var time: Date? = nil

    //以当前时间初始化
    init(t: Date? = nil) {
        self.time = t
    }

    init(timeIntervalSinceNow: TimeInterval) {
        self.time = Date(timeIntervalSinceNow: timeIntervalSinceNow)
    }

    //获取当前时间的Time
    static var now: Time {
        return Time(t: Date())
    }

    func getTimeData() -> Date {
        if time == nil {
            print("ERROR: time is nil in getTimeData")
            return Date()
        } else {
            return time!
        }
    }

    //根据当前时间获取不同的时间文本
    var toString: String {
        guard let t = time else {
            return "暂未确定"
        }

        let calendar = Calendar.current
        let dateCom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: t)

        let yesterday = Date(timeIntervalSinceNow: -3600 * 24)
        let yesterdayCom = calendar.dateComponents([.year, .month, .day], from: yesterday)

        var timeStr: String
        let dateNum = dateCom.year! * 10000 + dateCom.month! * 100 + dateCom.day!
        let yesterdayNum = yesterdayCom.year! * 10000 + yesterdayCom.month! * 100 + yesterdayCom.day!
        if dateNum < yesterdayNum {
            timeStr = String(dateCom.month!) + "-" + String(dateCom.day!)
        } else {
            timeStr = String(dateCom.hour!) + ":" + String(format: "%02d", dateCom.minute!)
        }

        return timeStr
    }

    var toWholeString: String {
        guard let t = time else {
            return "暂未确定"
        }

        let com = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: t)
        return String(com.month!) + "月" + String(com.day!) + "日 " +
            String(com.hour!) + ":" + String(format: "%02d", com.minute!)
    }

    var toLeftHourSineNow: Int {
        guard let t = time else {
            return 9999
        }

        return Int(floor(t.timeIntervalSinceNow / 3600))
    }
}

func ==(lhs: Time, rhs: Time) -> Bool {
    if lhs.time == nil || rhs.time == nil {
        print("ERROR: Time is nil in func ==")
        return false
    } else {
        let itvl = lhs.time!.timeIntervalSince(rhs.time!) // 不能用compare，因为会有float的误差造成判断错误
        return (-0.1 < itvl && itvl < 0.1)
    }
}

func <(lhs: Time, rhs: Time) -> Bool {
    if lhs.time == nil || rhs.time == nil {
        print("ERROR: Time is nil in func <")
        return false
    } else {
        return lhs.time! < rhs.time!
    }
}


//位置信息的封装 ----------------------------------------------------------------------------

// 用于获取当前位置
class LocationMgr: NSObject, AMapSearchDelegate {

    fileprivate static let shareInstance = LocationMgr()
    private var isSearching: Bool = false

    // loc ------------------------------------------------------------------------------
    private var mgr: AMapLocationManager? = nil

    func getCurLoc(callback: @escaping (Bool, CLLocation?, String?) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            callback(false, nil, nil)
            return
        }

        if isSearching == true {
            print("isSearching")
            return
        }
        isSearching = true

        if mgr == nil {
            mgr = AMapLocationManager()
            mgr!.desiredAccuracy = kCLLocationAccuracyBest
        }
        
        mgr!.requestLocation(withReGeocode: true) { loc, regeo, error in
            print("requestLocation callback", loc ?? "no loc", regeo ?? "no regeo", error ?? "no error")
            self.isSearching = false
            callback(error == nil, loc, regeo?.formattedAddress)
        }
    }

    var searchAPI: AMapSearchAPI? = nil
    var callForRegeo: ((Bool, String?) -> Void)? = nil
    func getCurAddress(by loc: CLLocation, callback: @escaping ((Bool, String?) -> Void)) {
        callForRegeo = callback

        if isSearching == true {
            print("isSearching")
            return
        }
        isSearching = true

        let reqRegeo = AMapReGeocodeSearchRequest()
        let l = loc.coordinate
        reqRegeo.location = AMapGeoPoint.location(withLatitude: CGFloat(l.latitude), longitude: CGFloat(l.longitude))

        if searchAPI == nil {
            searchAPI = AMapSearchAPI()!
            searchAPI!.delegate = self
        }
        searchAPI!.aMapReGoecodeSearch(reqRegeo)
    }

    // AMapSearchDelegate ---------------------------------------

    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        print("onReGeocodeSearchDone", response.regeocode)
        isSearching = false

        if let call = callForRegeo {
            call(true, response.regeocode.formattedAddress)
        }
    }

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("ERROR: aMapSearchRequest", error)
        isSearching = false
        if let call = callForRegeo {
            call(false, nil)
        }
    }


}

class Location: NSObject, AMapSearchDelegate {
    // 可空，空就是位置待定
    private(set) var loc: CLLocation
    private(set) var locString: String? = nil

    init (l: CLLocation? = nil) {
        self.loc = l ?? CLLocation(latitude: 0, longitude: 0)
    }

    func set(loc: CLLocation) {
        self.loc = loc
        self.locString = nil
    }

    // 回调：位置，位置文本，是否成功
    func fetchCurLoc(callback: @escaping ((CLLocation?, String?, Bool) -> Void)) {
        LocationMgr.shareInstance.getCurLoc() { suc, loc, address in
            self.loc = loc ?? CLLocation(latitude: 0, longitude: 0)
            self.locString = address
            callback(loc, address, suc)
        }
    }

    func fetchCurAddress(by loc: CLLocation, callback: @escaping ((String?, Bool) -> Void)) {
        LocationMgr.shareInstance.getCurAddress(by: loc) { suc, address in
            self.locString = address
            callback(address, suc)
        }
    }

    func isLocValid() -> Bool {
        let la = loc.coordinate.latitude
        let lo = loc.coordinate.longitude
        let laV: Bool = (la < -0.01) || (0.01 < la)
        let loV: Bool = (lo < -0.01) || (0.01 < lo)

        return laV && loV // 经纬度都不在0点视为合理
    }

    func getLoc(callback: @escaping ((CLLocation?) -> Void)) {
        if isLocValid() {
            callback(loc)
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
            if isLocValid() {
                fetchCurAddress(by: loc) { str, suc in
                    callback(suc ? str : nil)
                }
            } else {
                fetchCurLoc { loc, str, suc in
                    callback(suc ? str : nil)
                }
            }
        }
    }
}

//基础数据 ----------------------------------------------------------------------------

class BaseData: NSObject {
    var ID: DataID //本结构体的id
    init(ID: DataID) {
        self.ID = ID
    }
}
