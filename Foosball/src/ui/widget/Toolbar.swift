//
//  Toolbar.swift
//  Foosball
//  两个按钮
//  Created by 卢乐颜 on 2016/12/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class Toolbar: UIView {

    private static let w: CGFloat = UIScreen.main.bounds.width
    private static let h: CGFloat = 49
    private static let m: CGFloat = 15
    private static let midm: CGFloat = 8
    private static let hm: CGFloat = 7
    private static let btnWidth: CGFloat = (w - 2 * m - midm) / 2
    private static let btnHeight: CGFloat = h - 2 * hm

    let btn1: UIButton
    let btn2: UIButton

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        btn1 = UIButton(type: .custom)
        btn2 = UIButton(type: .custom)
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: Toolbar.w, height: Toolbar.h))

        backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3

        // 按钮
        addSubview(btn1)
        btn1.frame = CGRect(
            x: Toolbar.m,
            y: Toolbar.hm,
            width: Toolbar.btnWidth,
            height: Toolbar.btnHeight
        )
        btn1.setTitleColor(BaseColor, for: .normal)
        btn1.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        btn1.layer.cornerRadius = 3
        btn1.layer.borderColor = BaseColor.cgColor
        btn1.layer.borderWidth = 1

        addSubview(btn2)
        btn2.frame = CGRect(
            x: Toolbar.m + Toolbar.midm + Toolbar.btnWidth,
            y: Toolbar.hm,
            width: Toolbar.btnWidth,
            height: Toolbar.btnHeight
        )
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        btn2.backgroundColor = BaseColor
        btn2.layer.cornerRadius = 3
        btn2.layer.masksToBounds = true
    }
}
