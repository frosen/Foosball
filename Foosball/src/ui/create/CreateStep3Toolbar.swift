//
//  CreateStep3Toolbar.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/12/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol CreateStep3ToolbarDelegate {

}

class CreateStep3Toolbar: BaseToolbar {

    private static let m: CGFloat = 15
    private static let midm: CGFloat = 8
    private static let hm: CGFloat = 5
    private static let btnWidth: CGFloat = (BaseToolbar.w - 2 * m - midm) / 2
    private static let btnHeight: CGFloat = BaseToolbar.h - 2 * hm

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()

        // 按钮
        let btn1 = UIButton(type: .custom)
        addSubview(btn1)
        btn1.frame = CGRect(
            x: CreateStep3Toolbar.m,
            y: CreateStep3Toolbar.hm,
            width: CreateStep3Toolbar.btnWidth,
            height: CreateStep3Toolbar.btnHeight
        )
        btn1.setTitle("直接发布", for: .normal)
        btn1.setTitleColor(BaseColor, for: .normal)
        btn1.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        btn1.layer.cornerRadius = 3
        btn1.layer.borderColor = BaseColor.cgColor
        btn1.layer.borderWidth = 1

        let btn2 = UIButton(type: .custom)
        addSubview(btn2)
        btn2.frame = CGRect(
            x: CreateStep3Toolbar.m + CreateStep3Toolbar.midm + CreateStep3Toolbar.btnWidth,
            y: CreateStep3Toolbar.hm,
            width: CreateStep3Toolbar.btnWidth,
            height: CreateStep3Toolbar.btnHeight
        )
        btn2.setTitle("继续", for: .normal)
        btn2.setTitleColor(UIColor.white, for: .normal)
        btn2.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        btn2.backgroundColor = BaseColor
        btn2.layer.cornerRadius = 3
    }

    var delegate: CreateStep3ToolbarDelegate? = nil
}
