//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

let iconMargin: CGFloat = 6 //图标到边的距离

class DetailCellTools {
    class func createTitle(v: UIView, s: String) {
        let w: CGFloat = 10
        let h: CGFloat = 20
        let margin: CGFloat = 20

        let icon = UIView(frame: CGRect(x: margin, y: v.frame.height / 2 - h / 2, width: w, height: h))
        v.addSubview(icon)

        icon.backgroundColor = UIColor.orangeColor()

        let lbl = UILabel()
        v.addSubview(lbl)
        lbl.snp_makeConstraints{ make in
            make.left.equalTo(icon.snp_right).offset(20)
            make.centerY.equalTo(v.snp_centerY)
        }

        lbl.font = TitleFont
        lbl.textColor = TitleColor

        lbl.text = s
        lbl.sizeToFit()
    }
}

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
        //底部分割线
        let downLine = UIView(frame: CGRect(x: 0, y: h - 0.5, width: w, height: 0.5))
        contentView.addSubview(downLine)
        downLine.backgroundColor = LineColor

        //图
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

    override func setEvent(e: Event) {
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
    }
}

class DetailCashCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailTeamHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        DetailCellTools.createTitle(contentView, s: "队伍信息")
    }
}

class DetailTeamTitleCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    func createTitleLabel(s: String) -> UILabel {
        let l = UILabel()
        contentView.addSubview(l)

        l.font = TitleFont
        l.textColor = TitleColor

        l.text = s
        l.sizeToFit()

        return l
    }

    override func initData() {
        backgroundColor = UIColor.orangeColor()

        //中线
        let midLine = UIView(frame: CGRect(x: w / 2, y: 0, width: 1, height: h))
        print(midLine.frame, h)
        contentView.addSubview(midLine)
        midLine.backgroundColor = UIColor.blackColor()

        //左边
        let leftTeam = createTitleLabel("我方")
        contentView.addSubview(leftTeam)
        leftTeam.snp_makeConstraints{ make in
            make.centerX.equalTo(contentView.snp_right).multipliedBy(0.25)
            make.centerY.equalTo(contentView.snp_centerY)
        }

        //右边
        let rightTeam = createTitleLabel("对方")
        rightTeam.snp_makeConstraints{ make in
            make.centerX.equalTo(contentView.snp_right).multipliedBy(0.75)
            make.centerY.equalTo(contentView.snp_centerY)
        }
    }
}

class DetailTeamCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailScoreHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        DetailCellTools.createTitle(contentView, s: "比赛得分")
    }
}

class DetailScoreTitleCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailScoreCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailMsgHeadCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        DetailCellTools.createTitle(contentView, s: "消息")
    }
}

class DetailMsgTitleCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailMsgCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}



