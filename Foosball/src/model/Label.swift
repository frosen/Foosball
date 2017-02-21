//
//  Label.swift
//  Foosball
//
//  Created by luleyan on 2017/2/21.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class Label: BaseData {
    var type: Int = 1 // 类型 1为event item，2为promise
    var category: String = ""
    var txt: String = ""
    var imgUrl: String = ""
    var useCount: Int = 0 // 使用过的次数
}
