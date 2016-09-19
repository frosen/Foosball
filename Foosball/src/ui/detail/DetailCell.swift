//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

let margin: CGFloat = 20
let iconMargin: CGFloat = 6 //图标到边的距离

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
        title.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.right.equalTo(contentView.snp.right).inset(iconMargin)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = TitleFont
        title.textColor = TitleColor

        // 位置和时间显示
        position = UILabel()
        contentView.addSubview(position)
        position.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        position.font = TextFont
        position.textColor = TextColor

        createTime = UILabel()
        contentView.addSubview(createTime)
        createTime.snp.makeConstraints{ make in
            make.left.equalTo(position.snp.right).offset(20)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        createTime.font = TextFont
        createTime.textColor = TextColor
    }

    override func setEvent(_ e: Event, index: IndexPath) {
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
//        let rect = stringList[0].boundingRectWithSize(
//            CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(MAXFLOAT)),
//            options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil)
        return 88
    }

    override func initData() {
        //底部分割线
        let downLine = UIView()
        contentView.addSubview(downLine)
        downLine.bounds = CGRect(x: 0, y: 0, width: w, height: 0.5)
        downLine.snp.makeConstraints{ make in
            make.bottom.equalTo(contentView.snp.bottom)
        }
        downLine.backgroundColor = LineColor
    }
}

class DetailCashCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

// ============================================================================================================================

class DetailHeadCell: BaseCell {
    func createHead(_ v: UIView, s: String) {
        let w: CGFloat = 10
        let h: CGFloat = 20

        let icon = UIView(frame: CGRect(x: margin, y: v.frame.height / 2 - h / 2, width: w, height: h))
        v.addSubview(icon)

        icon.backgroundColor = UIColor.orange

        let lbl = UILabel()
        v.addSubview(lbl)
        lbl.snp.makeConstraints{ make in
            make.left.equalTo(icon.snp.right).offset(20)
            make.centerY.equalTo(v.snp.centerY)
        }

        lbl.font = TitleFont
        lbl.textColor = TitleColor

        lbl.text = s
        lbl.sizeToFit()
    }
}

class DetailListTitleCell: BaseCell {
    func createListTitle(leftStr: String, rightStr: String) -> (UILabel, UILabel) {
        backgroundColor = UIColor.orange

        //中线
        let midLine = UIView(frame: CGRect(x: w / 2, y: 0, width: 0.5, height: h))
        contentView.addSubview(midLine)
        midLine.backgroundColor = UIColor.black

        let left = createTitleLabel(leftStr, posRate: 0.25) //左边
        let right = createTitleLabel(rightStr, posRate: 0.75) //右边

        return (left, right)
    }

    func createTitleLabel(_ s: String, posRate: CGFloat) -> UILabel {
        let l = UILabel()
        contentView.addSubview(l)

        l.font = TitleFont
        l.textColor = TitleColor

        l.text = s
        l.sizeToFit()

        l.snp.makeConstraints{ make in
            make.centerX.equalTo(contentView.snp.right).multipliedBy(posRate)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        return l
    }
}

// ============================================================================================================================

class DetailTeamHeadCell: DetailHeadCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        createHead(contentView, s: "队伍信息")
    }
}

class DetailTeamTitleCell: DetailListTitleCell {
    var leftCount: UILabel! = nil
    var rightCount: UILabel! = nil

    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        let (left, right) = createListTitle(leftStr: "我方", rightStr: "对方")

        //显示人数
        leftCount = createPersonCountLabel(left)
        rightCount = createPersonCountLabel(right)
    }

    func createPersonCountLabel(_ posView: UIView) -> UILabel {
        let countLbl = UILabel()
        contentView.addSubview(countLbl)
        countLbl.snp.makeConstraints{ make in
            make.left.equalTo(posView.snp.right).offset(5)
            make.bottom.equalTo(posView.snp.bottom)
        }

        countLbl.font = UIFont.boldSystemFont(ofSize: 12)
        countLbl.textColor = UIColor(white: 0.3, alpha: 1)

        return countLbl
    }

    override func setEvent(_ e: Event, index: IndexPath) {
        //计算人数
        setCount(leftCount, count: e.ourSideStateList.count)
        setCount(rightCount, count: e.opponentStateList.count)
    }

    func setCount(_ lbl: UILabel, count: Int) {
        lbl.text = "(" + String(count) + ")"
        lbl.sizeToFit()
    }
}

class DetailTeamCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        //中线
        let midLine = UIView(frame: CGRect(x: w / 2, y: 0, width: 0.5, height: h))
        contentView.addSubview(midLine)
        midLine.backgroundColor = UIColor.black
    }

    override func setEvent(_ e: Event, index: IndexPath) {
        if (index as NSIndexPath).row % 2 == 1 {//隔行把颜色稍稍加深
            backgroundColor = UIColor(red: 1.0, green: 0.9, blue: 0.8, alpha: 1.0)
        } else {
            backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }
    }
}

class DetailScoreHeadCell: DetailHeadCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        createHead(contentView, s: "比赛得分")
    }
}

class DetailScoreTitleCell: DetailListTitleCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        let _ = createListTitle(leftStr: "我方", rightStr: "对方")
    }
}

class DetailScoreCell: BaseCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
    }
}

class DetailMsgHeadCell: DetailHeadCell {
    override class func getCellHeight() -> CGFloat {
        return 44
    }

    override func initData() {
        createHead(contentView, s: "消息")
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



