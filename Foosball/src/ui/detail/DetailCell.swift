//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailTitleCell: BaseCell {
    var icon: UIImageView! = nil
    var title: UILabel! = nil
    var position: UILabel! = nil
    var createTime: UILabel! = nil

    var imgURL: String = ""

    override class func getCellHeight() -> CGFloat {
        return 72
    }

    override func initData() {
        self.accessoryType = .None

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = DetailTitleCell.getCellHeight()

        //底部分割线
        let downLine = UIView(frame: CGRect(x: 0, y: h - 0.5, width: w, height: 0.5))
        contentView.addSubview(downLine)
        downLine.backgroundColor = LineColor

        //图
        let iconMargin: CGFloat = 6
        let (iconView, iconTmp) = EventIcon.create(h, iconMargin: iconMargin)
        addSubview(iconView)
        icon = iconTmp

        //标题
        let stringOffset: CGFloat = 20
        title = UILabel()
        contentView.addSubview(title)
        title.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right).offset(stringOffset)
            make.right.equalTo(contentView.snp_right).inset(iconMargin)
            make.centerY.equalTo(contentView.snp_bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = TitleFont
        title.textColor = TitleColor

        // 位置和时间显示
        position = UILabel()
        contentView.addSubview(position)
        position.snp_makeConstraints{ make in
            make.left.equalTo(iconView.snp_right).offset(stringOffset)
            make.centerY.equalTo(contentView.snp_bottom).multipliedBy(0.7) //0.3 0.7
        }

        position.font = TextFont
        position.textColor = TextColor

        createTime = UILabel()
        contentView.addSubview(createTime)
        createTime.snp_makeConstraints{ make in
            make.left.equalTo(position.snp_right).offset(20)
            make.centerY.equalTo(contentView.snp_bottom).multipliedBy(0.7) //0.3 0.7
        }

        createTime.font = TextFont
        createTime.textColor = TextColor
    }

    func setData(e: Event) {
        title.text = "这也是一个很有趣的测试"
        title.sizeToFit()
        position.text = "朝阳/6km"
        position.sizeToFit()
        createTime.text = "1小时前"
        createTime.sizeToFit()
    }
}

class DetailContentCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 88
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailCashCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailTeamHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailTeamCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailScoreHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailScoreCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailMsgHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}

class DetailMsgCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        self.accessoryType = .DisclosureIndicator
    }
}



