//
//  Event.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ItemTypeType {
    var count: Int = 0
}

let Sport = ItemTypeType()
let E_sport = ItemTypeType()

class ItemType {
    static var count: Int = 0
    let itemTypeType: ItemTypeType
    init(itemTypeType: ItemTypeType) {
        ItemType.count += 1

        self.itemTypeType = itemTypeType
        itemTypeType.count += 1
    }
}

let Foosball = ItemType(itemTypeType: Sport)
let LOL = ItemType(itemTypeType: E_sport)



class Event: NSObject {
    //项目
    var item: ItemType

    //类型
//    var type: EventType

    //组队还是个人

    //发送方

    //接收方

    //兑现物

    //状态

    //对话list

    //位置信息

    init(item: ItemType) {
        self.item = item
        super.init()

    }
}
