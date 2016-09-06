//
//  BaseCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        initData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }

    func initData() {}
}
