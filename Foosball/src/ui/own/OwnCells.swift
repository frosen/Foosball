//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnTitleCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let h = Int(OwnTitleCell.getCellHeight())

        //背景
        let bg = UIImageView(image: UIImage(named: "selfbg"))
        contentView.addSubview(bg)
        bg.frame = CGRect(x: 0, y: 0, width: Int(UIScreen.mainScreen().bounds.width), height: h)

        //头像
        let avatar = UIImageView(image: UIImage(named: "default_avatar"))
        contentView.addSubview(avatar)
        let avatarW: CGFloat = 90
        avatar.snp_makeConstraints { make in
            make.size.equalTo(CGSize(width: avatarW, height: avatarW))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(15)
        }

        avatar.layer.cornerRadius = avatarW / 2 //圆形
        avatar.layer.masksToBounds = true //剪切掉边缘以外
        avatar.layer.borderColor = UIColor.purpleColor().CGColor
        avatar.layer.borderWidth = 1.5

        let nameView = UIView()
        contentView.addSubview(nameView)
        nameView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        let nameVW: CGFloat = 270
        let nameVH: CGFloat = 30
        nameView.snp_makeConstraints { make in
            make.size.equalTo(CGSize(width: nameVW, height: nameVH))
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(bg.snp_bottom).offset(-5)
        }
        nameView.layer.cornerRadius = nameVH / 3 //圆形
        nameView.layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 200
    }
}

class OwnQRCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let bg = UIImageView(image: UIImage(named: ""))
        self.contentView.addSubview(bg)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 80
    }
}

class OwnNormalCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        textLabel?.font = UIFont.systemFontOfSize(13)
        detailTextLabel?.font = UIFont.systemFontOfSize(13)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }
}
