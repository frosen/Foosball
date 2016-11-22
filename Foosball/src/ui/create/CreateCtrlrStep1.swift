//
//  CreateCtrlrStep1.swift
//  Foosball
//
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateCtrlrStep1: CreatePageBaseCtrlr {

    override func setUI() {
        view.backgroundColor = UIColor.red

        let v = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        v.backgroundColor = UIColor.blue
        view.addSubview(v)

        print("vv", view.frame)
        let v2 = UIView(frame: CGRect(x: 0, y: pageSize.height - 20, width: 20, height: 20))
        v2.backgroundColor = UIColor.blue
        view.addSubview(v2)

        let v3 = UIView(frame: CGRect(x: 20, y: pageSize.height - 120, width: 20, height: 120))
        v3.backgroundColor = UIColor.blue
        view.addSubview(v3)
    }
}
