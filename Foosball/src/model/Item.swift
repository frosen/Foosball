//
//  Item.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ItemTypeType {
    static var count: Int = 0
    var subcount: Int = 0
    var name: String = ""

    static func new(name: String) -> ItemTypeType {
        let t = ItemTypeType()
        t.name = name
        ItemTypeType.count += 1
        return t
    }

    static let Sport = ItemTypeType.new(name: "体育运动")
    static let E_sport = ItemTypeType.new(name: "电子竞技")
}

class ItemType {
    static var count: Int = 0
    static var list: [ItemType] = []

    var itemTypeType: ItemTypeType! = nil
    var name: String = ""

    static func new(itemTypeType: ItemTypeType, name: String) {
        let t = ItemType()

        t.itemTypeType = itemTypeType
        t.name = name

        ItemType.count += 1
        itemTypeType.subcount += 1

        ItemType.list.append(t)
    }

    // 为什么要这样init呢？
    // 因为如果使用静态直接生成（static let Sport = ItemTypeType.new(name: "体育运动")）是不行的
    // 大概swift里面会把这条当做一个函数，只有调用时才会走new这个函数，所以数量统计就是错误的
    // 因此，需要写个方法，在初始化时调用
    static func initAllItem() {
        ItemType.new(itemTypeType: .Sport,   name: "桌上足球")
        ItemType.new(itemTypeType: .E_sport, name: "英雄联盟")
    }
}







