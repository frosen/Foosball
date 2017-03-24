//
//  Item.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class Label: NSObject {
    enum LabelType {
        case item
        case promise
    }

    var type: LabelType = .item
    var category: String = ""
    var name: String = ""
}

class Item: Label {
    init(name: String = "", category: String = "") {
        super.init()
        self.type = .item
        self.name = name
        self.category = category
    }
}

class Promise: Label {
    init(name: String = "", category: String = "") {
        super.init()
        self.type = .promise
        self.name = name
        self.category = category
    }
}








