//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

let headMargin: CGFloat = 15
let iconMargin: CGFloat = 6 //图标到边的距离

class DetailTitleCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        //底部分割线
        createDownLine()

        //图
        let (iconView, _) = EventIcon.create(h, iconMargin: iconMargin)
        addSubview(iconView)

        //标题
        let stringOffset: CGFloat = 20
        let title = UILabel()
        contentView.addSubview(title)
        title.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.right.equalTo(contentView.snp.right).inset(iconMargin)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = TitleFont
        title.textColor = TitleColor

        // 位置和时间显示
        let position = UILabel()
        contentView.addSubview(position)
        position.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        position.font = TextFont
        position.textColor = TextColor

        let createTime = UILabel()
        contentView.addSubview(createTime)
        createTime.snp.makeConstraints{ make in
            make.left.equalTo(position.snp.right).offset(20)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        createTime.font = TextFont
        createTime.textColor = TextColor

        //赋值 -------------------------------------------------------------
        title.text = "这也是一个很有趣的测试"
        title.sizeToFit()
        position.text = "朝阳/6km"
        position.sizeToFit()
        createTime.text = "1小时前"
        createTime.sizeToFit()
    }
}

class DetailContentCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
//        let rect = stringList[0].boundingRectWithSize(
//            CGSize(width: UIScreen.mainScreen().bounds.width, height: CGFloat(MAXFLOAT)),
//            options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName : UIFont.systemFontOfSize(17)], context: nil)
        return 88
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        //底部分割线
        createDownLine()
    }
}

class DetailCashCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
    }
}

// ============================================================================================================================

class DetailHeadCell: BaseCell {
    func createHead(_ v: UIView, s: String) {
        let vw: CGFloat = 10
        let vh: CGFloat = 20

        let icon = UIView(frame: CGRect(x: headMargin, y: v.frame.height / 2 - vh / 2, width: vw, height: vh))
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

// ============================================================================================================================

class DetailTeamHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        createHead(contentView, s: "队伍")

        //底线
        createDownLine()
    }
}

// 一行5个头像，头像下面有名字（因为也不一定会有很多人愿意发头像上来，再没有名字就不知道是谁了）
// 超过5个则换行
// 分成友方，敌方，观众
let avatarCountIn1Line: Int = 5
class DetailTeamCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event?
        var avatarRowCount: Int
        switch index!.row {
        case 0:
            avatarRowCount = Int(Float(e!.ourSideStateList.count) / Float(avatarCountIn1Line)) + 1
        case 1:
            avatarRowCount = Int(Float(e!.opponentStateList.count) / Float(avatarCountIn1Line)) + 1
        default:
            avatarRowCount = 0
        }
        return CGFloat(avatarRowCount * 84) + 39
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        //底线
        createDownLine()

        //图标和标题
        let icon = UIImageView(frame: CGRect(x: headMargin, y: 13, width: 13, height: 13))
        contentView.addSubview(icon)
        icon.image = UIImage(named: "team")




        let title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.center.equalTo(icon.snp.center)
            make.left.equalTo(icon.snp.left).offset(33)
        }
        title.font = UIFont.systemFont(ofSize: 23)
        //赋值 ---------------------------------------------------------
        title.text = "友方"
        title.sizeToFit()
    }
}

class DetailImageHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        createHead(contentView, s: "瞬间")
    }
}

class DetailImageCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
    }
}

class DetailMsgHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        createHead(contentView, s: "消息")
    }
}

class DetailMsgCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
    }
}



