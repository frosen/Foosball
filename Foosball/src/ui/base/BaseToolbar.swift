//
//  BaseToolbar.swift
//  Foosball
//
//  Created by luleyan on 2016/12/19.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class BaseToolbar: UIView {

    static let w: CGFloat = UIScreen.main.bounds.width
    static let h: CGFloat = 40

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: BaseToolbar.w, height: BaseToolbar.h))

        backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
    }
}
