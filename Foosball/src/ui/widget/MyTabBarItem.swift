//
//  MyTabBarItem.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/9.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class MyTabBarItem: UIButton {

    private var item: UITabBarItem? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(UIColor.black, for: UIControlState())

        imageView!.contentMode = .center //图片居中
        titleLabel!.textAlignment = .center //文字居中
        titleLabel!.font = UIFont.systemFont(ofSize: 10) //设置文字字体
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //屏蔽hightlight事件
    override var isHighlighted: Bool {
        set {}
        get {
            return super.isHighlighted
        }
    }

    func setItem(_ it: UITabBarItem) {
        item = it

        setTitle(item!.title, for: UIControlState())
        setImage(item!.image, for: UIControlState())
        setImage(item!.image?.withRenderingMode(.alwaysTemplate), for: .selected)
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
        setTitleColor(tintColor, for: .selected)
    }

}






