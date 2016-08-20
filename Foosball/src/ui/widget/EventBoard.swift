//
//  EventBoard.swift
//  Foosball
//  事件信息展示板，用在多个cell中
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

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
        downLine.backgroundColor = UIColor(white: 0.92, alpha: 1)

        //图标所在view，为布局而用
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: h, height: h))
        addSubview(iconView)
        
        //图标
        let iconWidth: CGFloat = 54
        icon = UIImageView(frame: CGRect(x: 8, y: 8, width: iconWidth, height: iconWidth))
        iconView.addSubview(icon)

        icon.layer.cornerRadius = iconWidth / 4 //圆形
        icon.layer.masksToBounds = true //剪切掉边缘以外

        icon.backgroundColor = UIColor.redColor()

        //临时的文字---------------------------
        let nameTmp = UILabel()
        icon.addSubview(nameTmp)
        nameTmp.text = "红牛杯"
        nameTmp.textColor = UIColor.whiteColor()
        nameTmp.font = UIFont.boldSystemFontOfSize(15)
        nameTmp.sizeToFit()
        nameTmp.center = CGPoint(x: iconWidth / 2, y: iconWidth / 2)

        //标题
        title = UILabel()
        addSubview(title)
        title.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right)
            make.centerY.equalTo(self.snp_bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = UIFont.boldSystemFontOfSize(15)
        title.textColor = UIColor.blackColor()

        title.text = "这是一个很有意思的测试"

        //VS显示处用于布局的view
        let VSView = UIView()
        addSubview(VSView)
        VSView.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right)
            make.right.equalTo(self.snp_right).inset(5)
            make.centerY.equalTo(self.snp_bottom).multipliedBy(0.7)
            make.height.equalTo(25)
        }

        VSView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        VSView.layer.cornerRadius = 3 //圆角
        VSView.layer.masksToBounds = true //剪切掉边缘以外

        let VS = UILabel()
        VSView.addSubview(VS)
        VS.snp_makeConstraints{ make in
            make.center.equalTo(VSView.snp_center)
        }

        VS.font = UIFont.boldSystemFontOfSize(15)
        VS.textColor = UIColor.blackColor()
        VS.text = "VS"

    }

    func setData(event: Event) {
        
    }
}
