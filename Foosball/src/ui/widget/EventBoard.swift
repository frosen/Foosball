//
//  EventBoard.swift
//  Foosball
//  事件信息展示板，用在多个cell中
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class EventIcon {
    class func create(h: CGFloat, iconMargin: CGFloat) -> (UIView, UIImageView) {
        //图标所在view，为布局而用
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: h, height: h))

        //图标
        let iconMargin: CGFloat = 6
        let iconWidth: CGFloat = h - iconMargin - iconMargin
        let icon = UIImageView(frame: CGRect(x: iconMargin, y: iconMargin, width: iconWidth, height: iconWidth))
        iconView.addSubview(icon)

        icon.layer.borderWidth = 3
        icon.layer.borderColor = UIColor.whiteColor().CGColor
        icon.layer.shadowColor = UIColor.grayColor().CGColor
        icon.layer.shadowOffset = CGSize(width: 1, height: 1)
        icon.layer.shadowOpacity = 0.9
        icon.layer.shadowRadius = 3

        icon.backgroundColor = UIColor.redColor()

        return (iconView, icon)
    }
}

class EventBoard: UIView {

    var icon: UIImageView! = nil
    var title: UILabel! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = 72
        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        //底部分割线
        let downLine = UIView(frame: CGRect(x: 0, y: h - 0.5, width: w, height: 0.5))
        addSubview(downLine)
        downLine.backgroundColor = LineColor

        let iconMargin: CGFloat = 6
        let (iconView, iconTmp) = EventIcon.create(h, iconMargin: iconMargin)
        addSubview(iconView)
        icon = iconTmp

        //标题
        title = UILabel()
        addSubview(title)
        title.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right).offset(5)
            make.right.equalTo(self.snp_right).inset(iconMargin)
            make.centerY.equalTo(self.snp_bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = TitleFont
        title.textColor = TitleColor
//        title.textAlignment = .Center
//        title.backgroundColor = UIColor(white: 0.95, alpha: 1)

        //VS显示处用于布局的view
        let VSView = UIView()
        addSubview(VSView)
        VSView.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right)
            make.right.equalTo(self.snp_right).inset(iconMargin)
            make.centerY.equalTo(self.snp_bottom).multipliedBy(0.7)
            make.height.equalTo(25)
        }

        VSView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        VSView.layer.cornerRadius = 3 //圆角
//        VSView.layer.masksToBounds = true //剪切掉边缘以外

        let VS = UILabel()
        VSView.addSubview(VS)
        VS.snp_makeConstraints{ make in
            make.center.equalTo(VSView.snp_center)
        }

        VS.font = UIFont.boldSystemFontOfSize(15)
        VS.textColor = UIColor.blackColor()
        VS.textAlignment = .Center
        VS.text = "VS"

        // 左右
        let left = UILabel()
        VSView.addSubview(left)
        left.snp_makeConstraints{ make in
            make.left.equalTo(VSView.snp_left)
            make.right.equalTo(VSView.snp_centerX)
            make.centerY.equalTo(VSView.snp_centerY)
        }

        left.font = UIFont.boldSystemFontOfSize(12)
        left.textColor = UIColor.blackColor()
        left.textAlignment = .Center
        left.text = "left"

        let right = UILabel()
        VSView.addSubview(right)
        right.snp_makeConstraints{ make in
            make.left.equalTo(VSView.snp_centerX)
            make.right.equalTo(VSView.snp_right)
            make.centerY.equalTo(VSView.snp_centerY)
        }

        right.font = UIFont.boldSystemFontOfSize(12)
        right.textColor = UIColor.blackColor()
        right.textAlignment = .Center
        right.text = "right"
    }

    func setData(event: Event) {
        //临时的文字---------------------------
        for v in icon.subviews { v.removeFromSuperview() }
        let nameTmp = UILabel()
        icon.addSubview(nameTmp)
        nameTmp.text = "XXX杯"
        nameTmp.textColor = UIColor.whiteColor()
        nameTmp.font = UIFont.boldSystemFontOfSize(15)
        nameTmp.sizeToFit()
        nameTmp.center = CGPoint(x: icon.frame.width / 2, y: icon.frame.height / 2)

        title.text = "这是一个很有意思的测试"
    }
}
