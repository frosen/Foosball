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
class LocationMgr: NSObject, CLLocationManagerDelegate, AMapSearchDelegate {

    fileprivate static let shareInstance = LocationMgr()
    private var isSearching: Bool = false

    // loc ------------------------------------------------------------------------------
    private var mgr: CLLocationManager? = nil

    var callForLoc: ((CLLocation?) -> Void)? = nil
    func getCurLoc(callback: @escaping (CLLocation?) -> Void) {
        guard CLLocationManager.locationServicesEnabled() else {
            callback(nil)
            return
        }

        callForLoc = callback

        if isSearching == true {
            print("isSearching")
            return
        }
        isSearching = true

        if mgr == nil {
            mgr = CLLocationManager()
            mgr!.delegate = self
        }
        mgr!.startUpdatingLocation()
    }

    // CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations", locations[0].coordinate)
        isSearching = false

        if let callback = callForLoc {
            callback(locations[0])
        }
        manager.stopUpdatingLocation()
        callForLoc = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: locationManager", error)
        isSearching = false
        if let callback = callForLoc {
            callback(nil)
        }
    }

    // regeo ------------------------------------------------------------------------------

    var searchAPI: AMapSearchAPI? = nil
    var callForRegeo: ((String?) -> Void)? = nil

    func getDressString(from loc: CLLocationCoordinate2D, callback: @escaping ((String?) -> Void)) {
        callForRegeo = callback

        if isSearching == true {
            print("isSearching")
            return
        }
        isSearching = true

        let reqRegeo = AMapReGeocodeSearchRequest()
        reqRegeo.location = AMapGeoPoint.location(withLatitude: CGFloat(loc.latitude), longitude: CGFloat(loc.longitude))

        if searchAPI == nil {
            searchAPI = AMapSearchAPI()!
            searchAPI!.delegate = self
        }
        searchAPI!.aMapReGoecodeSearch(reqRegeo)
    }

    // AMapSearchDelegate ---------------------------------------

    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
        print("onReGeocodeSearchDone")
        isSearching = false

        if let regeo = response.regeocode {
            print(regeo.formattedAddress)
            print("--", regeo.addressComponent.province)
            print("--", regeo.addressComponent.city)
            print("--", regeo.addressComponent.citycode)
            print("--", regeo.addressComponent.district)
            print("--", regeo.addressComponent.adcode)
            print("--", regeo.addressComponent.township)
            print("--", regeo.addressComponent.towncode)
            print("--", regeo.addressComponent.neighborhood)
            print("--", regeo.addressComponent.building)
            print("--", regeo.addressComponent.streetNumber.street)
            print("--", regeo.addressComponent.streetNumber.number)
            if let call = callForRegeo {
                call(regeo.formattedAddress)
            }
        }
    }

    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("ERROR: aMapSearchRequest", error)
        isSearching = false
        if let call = callForRegeo {
            call(nil)
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
        LocationMgr.shareInstance.getCurLoc() { loc in
            self.loc = loc
            callback(loc, nil, (loc != nil))

            if loc != nil {
                LocationMgr.shareInstance.getDressString(from: loc!.coordinate) { str in
                    self.locString = str
                    callback(loc, str, (str != nil))
                }
            }
        }
    }

    func getAddress(callback: @escaping ((String?) -> Void)) {
        if let ad = locString {
            callback(ad)
        } else {
            fetchCurLoc { loc, str, suc in
                if suc == false {
                    callback(nil)
                } else {
                    if let s = str {
                        callback(s)
                    }
                }
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
