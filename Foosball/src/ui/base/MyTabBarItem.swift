//
//  MyTabBarItem.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/9.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class MyTabBarItem: UIButton {

    var _item: UITabBarItem? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(UIColor.blackColor(), forState: .Normal)

        imageView!.contentMode = .Center //图片居中
        titleLabel!.textAlignment = .Center //文字居中
        titleLabel!.font = UIFont.systemFontOfSize(10) //设置文字字体
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //屏蔽hightlight事件
    override var highlighted: Bool {
        set {}
        get {
            return super.highlighted
        }
    }

    func setItem(item: UITabBarItem) {
        _item = item

        setTitle(_item!.title, forState: .Normal)
        setImage(_item!.image, forState: .Normal)
        setImage(_item!.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Selected)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let imageH = bounds.size.height * 0.7
        imageView?.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.size.width,
            height: imageH)

        let titleY = imageH - 3
        titleLabel?.frame = CGRect(
            x: 0,
            y: titleY,
            width: bounds.size.width,
            height: bounds.size.height - titleY)

    }

    override func tintColorDidChange() {
        setTitleColor(tintColor, forState: .Selected)
    }

}






