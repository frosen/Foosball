//
//  CreateStep3Cell.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/12/11.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3TimeCell: StaticCell {

    private let cellStyle: UITableViewCellStyle = .value1

    override func initData(_ d: BaseData?, index: IndexPath?) {
        textLabel?.text = "时间"
        detailTextLabel?.text = "2015年15月32日"
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {

    }
}
