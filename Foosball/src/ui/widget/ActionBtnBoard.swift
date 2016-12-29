//
//  ActionBtnBoard.swift
//  Foosball
//
//  Created by luleyan on 2016/12/29.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ActionBtnBoard: UIView {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
    }
}
