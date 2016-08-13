//
//  ChallengeCell.swift
//  Foosball
//
//  Created by 卢乐颜 on 16/8/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {

    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = ChallengeCell.getCellHeight()
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        //分割线
        let downLine = UIView(frame: CGRect(x: 0, y: h - 0.5, width: w, height: 0.5))
        contentView.addSubview(downLine)
        downLine.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)

        //图标
        let iconWidth: CGFloat = 54
        let icon = UIView(frame: CGRect(x: 6, y: 6, width: iconWidth, height: iconWidth))
        contentView.addSubview(icon)

        icon.layer.cornerRadius = iconWidth / 2 //圆形
        icon.layer.masksToBounds = true //剪切掉边缘以外

        icon.backgroundColor = UIColor.brownColor()

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 99
    }

    func setData()

}
