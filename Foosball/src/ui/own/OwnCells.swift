//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnTitleCell: UITableViewCell {
    var bg: UIImageView? = nil
    var avatar: UIImageView? = nil
    var title: UILabel? = nil
    var subTitle: UILabel? = nil

    var leftView: UIView? = nil
    var rightView: UIView? = nil

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let w = Int(UIScreen.mainScreen().bounds.width)
        let h = Int(OwnTitleCell.getCellHeight())

        //背景
        bg = UIImageView(image: UIImage(named: "selfbg"))
        contentView.addSubview(bg!)
        bg!.frame = CGRect(x: 0, y: 0, width: w, height: h)
        bg!.contentMode = .ScaleAspectFill

        //头像
        avatar = UIImageView(image: UIImage(named: "default_avatar"))
        contentView.addSubview(avatar!)
        let avatarW: CGFloat = 70
        avatar!.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: avatarW, height: avatarW))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(-13.0)
        }

        avatar!.layer.cornerRadius = avatarW / 2 //圆形
        avatar!.layer.masksToBounds = true //剪切掉边缘以外

        avatar!.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).CGColor
        avatar!.layer.borderWidth = 1.5

        //左侧标志

        //右侧标志

        //名字
        title = UILabel()
        contentView.addSubview(title!)
        title!.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: w, height: Int(Double(h) * 0.2)))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView.snp_bottom).offset(-43.0)
        }
        title!.textAlignment = NSTextAlignment.Center
        title!.font = UIFont.systemFontOfSize(14.0)
        title!.text = "聂小倩"
        title!.textColor = UIColor.whiteColor()

        title!.shadowColor = UIColor.blackColor()
        title!.shadowOffset = CGSize(width: 1, height: 1)

        //签名
        subTitle = UILabel()
        contentView.addSubview(subTitle!)
        subTitle!.snp_makeConstraints{ make in
            make.size.equalTo(CGSize(width: w, height: Int(Double(h) * 0.1)))
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView.snp_bottom).offset(-24.0)
        }
        subTitle!.textAlignment = NSTextAlignment.Center
        subTitle!.font = UIFont.systemFontOfSize(11.0)
        subTitle!.text = "个性签名，啦啦啦"
        subTitle!.textColor = UIColor.whiteColor()

        subTitle!.shadowColor = UIColor.blackColor()
        subTitle!.shadowOffset = CGSize(width: 1, height: 1)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 160
    }

//    func setScrollView(scrollView: UIScrollView) {
//
//    }
//
//    func onUpdateSrollOffsetY(newOffsetY: Float) {
//
//    }
}

class OwnQRCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

//        let bg = UIImageView(image: UIImage(named: ""))
//        self.contentView.addSubview(bg)
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
