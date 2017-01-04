//
//  CreateStep3Toolbar.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/12/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol CreateStep3ToolbarDelegate {
    func onPublish()
    func onGoon()
}

class CreateStep3Toolbar: BaseToolbar {

    private static let m: CGFloat = 15
    private static let midm: CGFloat = 8
    private static let hm: CGFloat = 5
    private static let btnWidth: CGFloat = BaseToolbar.w / 2
    private static let btnHeight: CGFloat = BaseToolbar.h - 2 * hm

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()

        let font = UIFont.systemFont(ofSize: 12)

        // 按钮
        let btn1 = UIButton(type: .custom)
        addSubview(btn1)
        btn1.frame = CGRect(x: 0, y: 0, width: BaseToolbar.w / 2, height: BaseToolbar.h)
        btn1.setTitleColor(UIColor.gray, for: .normal)
        btn1.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn1.titleLabel!.font = font

        btn1.setTitle(" 直接发布 ", for: .normal)
        btn1.setImage(#imageLiteral(resourceName: "act_btn_confirm"), for: .normal)
        btn1.addTarget(self, action: #selector(CreateStep3Toolbar.onPublish), for: .touchUpInside)

        let btn2 = UIButton(type: .custom)
        addSubview(btn2)
        btn2.frame = CGRect(x: BaseToolbar.w / 2, y: 0, width: BaseToolbar.w / 2, height: BaseToolbar.h)
        btn2.setTitleColor(UIColor.gray, for: .normal)
        btn2.setTitleColor(UIColor.lightGray, for: .highlighted)
        btn2.titleLabel!.font = font

        btn2.setTitle(" 继续 ", for: .normal)
        btn2.setImage(#imageLiteral(resourceName: "act_btn_confirm"), for: .normal)
        btn2.addTarget(self, action: #selector(CreateStep3Toolbar.onGoon), for: .touchUpInside)
    }

    var delegate: CreateStep3ToolbarDelegate? = nil

    func onPublish() {
        delegate?.onPublish()
    }

    func onGoon() {
        delegate?.onGoon()
    }
}
