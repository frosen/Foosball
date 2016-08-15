//
//  Item.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
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
