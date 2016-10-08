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

//对时间表示的封装
struct Time {
    let time: Date

    //以当前时间初始化
    init(t: Date) {
        self.time = t
    }

    //获取当前时间的Time
    static var now: Time {
        return Time(t: getCurrentTime())
    }

    static fileprivate func getCurrentTime() -> Date {
        let zone: TimeZone = TimeZone.current // 设置系统时区为本地时区
        let second: Int = zone.secondsFromGMT() // 计算本地时区与 GMT 时区的时间差
        return Date(timeIntervalSinceNow: TimeInterval(second)) // 在 GMT 时间基础上追加时间差值，得到本地时间
    }

    //根据当前时间获取不同的时间文本
    func toString() -> String {
        let now = Time.getCurrentTime()

        let interval: TimeInterval = now.timeIntervalSince(time)

        var timeStr: String
        if interval < 60 {
            timeStr = "刚刚"
        } else if interval < 3600 {
            let min = floor(interval / 60)
            timeStr = String(min) + "分钟前"
        } else if interval < 3600 * 24 {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            timeStr = formatter.string(from: time)
        } else {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "MM月dd日"
            timeStr = formatter.string(from: time)
        }
        print(timeStr)

        return timeStr
    }

    func toWholeString() -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日HH点mm分"
        return formatter.string(from: time)
    }
}

//位置信息的封装
struct Location {
    
}

//数据核心
class Data: NSObject {
    let ID: DataID //本结构体的id
    init(ID: DataID) {
        self.ID = ID
    }
}
