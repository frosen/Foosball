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
    var title: UILabel! = nil
    var position: UILabel! = nil
    var createTime: UILabel! = nil

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

    override func setData(_ d: Data?, index: IndexPath?) {
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

// =============================================================================================================

class DetailHeadCell: BaseCell {
    func createHead(_ s: String) {
        let vw: CGFloat = 15
        let vh: CGFloat = 15

        let icon = UIImageView(frame: CGRect(x: headMargin, y: contentView.frame.height / 2 - vh / 2, width: vw, height: vh))
        contentView.addSubview(icon)
        icon.image = UIImage(named: "detail_cell_icon")
//        icon.backgroundColor = UIColor.orange

        let lbl = UILabel()
        contentView.addSubview(lbl)
        lbl.snp.makeConstraints{ make in
            make.left.equalTo(icon.snp.right).offset(headMargin)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        lbl.font = TitleFont
        lbl.textColor = TitleColor

        lbl.text = s
        lbl.sizeToFit()
    }

    func createButton() {
        
    }
}

// ==================================================================================================================

class DetailTeamHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        createHead("队伍")

        // 邀请按钮
        let btn = UIButton(type: .system)
        contentView.addSubview(btn)

        btn.snp.makeConstraints{ make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(headMargin)
            make.size.equalTo(CGSize(width: 65, height: 25))
        }

        btn.setTitle("邀请", for: .normal)
        btn.titleLabel?.font = TextFont
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.purple
        btn.layer.cornerRadius = 5


        //底线
        createDownLine()
    }
}

// 一行5个头像，头像下面有名字（因为也不一定会有很多人愿意发头像上来，再没有名字就不知道是谁了）
// 超过5个则换行
// 分成友方，敌方，观众
let memberCountIn1Line: CGFloat = 6
let memberViewHeight: CGFloat = 84
let memberTitleHeight: CGFloat = 39
class DetailTeamCell: BaseCell {
    var title: UILabel! = nil
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event?
        var avatarRowRate: CGFloat
        switch index!.row {
        case 1:
            avatarRowRate = CGFloat(e!.ourSideStateList.count) / memberCountIn1Line
        case 2:
            avatarRowRate = CGFloat(e!.opponentStateList.count) / memberCountIn1Line
        default:
            avatarRowRate = 0
        }
        let avatarRowCount = ceil(avatarRowRate)
        return avatarRowCount * memberViewHeight + memberTitleHeight
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        //底线
        createDownLine()

        //图标题
        title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(13)
            make.left.equalTo(contentView.snp.left).offset(headMargin)
        }
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = TextColor


    }

    var curRow: Int = -1
    let avatarMargin: CGFloat = 3
    override func setData(_ d: Data?, index: IndexPath?) {
        if curRow == index!.row {
            return // row不变里面内容视为不变
        }
        curRow = index!.row

        switch curRow {
        case 1:
            title.text = "友方人员"
        case 2:
            title.text = "对方人员"
        default:
            title.text = "观战者"
        }

        title.sizeToFit()

        //设置member
        let e: Event = d as! Event
        let memberList: [UserState]
        switch curRow {
        case 1:
            memberList = e.ourSideStateList
        case 2:
            memberList = e.opponentStateList
        default:
            memberList = []
        }

        var pos: Int = 0
        var line: Int = 0
        let margin = headMargin - avatarMargin
        for m in memberList {
            let v = createMemberView(m)
            contentView.addSubview(v)
            let f = v.frame
            v.frame = CGRect(
                x: CGFloat(pos) * f.width + margin,
                y: CGFloat(line) * f.height + memberTitleHeight,
                width: f.width,
                height: f.height
            )

            pos += 1
            if pos >= Int(memberCountIn1Line) {
                pos = 0
                line += 1
            }
        }
    }

    func createMemberView(_ state: UserState) -> UIView {
        let userB = state.user
        let v = UIView()
        let totalWidth = w - 2 * (headMargin - avatarMargin)
        v.bounds = CGRect(x: 0, y: 0, width: totalWidth / memberCountIn1Line, height: memberViewHeight)

        // 头像
        let avatarWidth = v.frame.width - 2 * avatarMargin
        let avatar = UITools.createAvatar(
            CGRect(x: avatarMargin, y: avatarMargin, width: avatarWidth, height: avatarWidth),
            name: userB.name,
            url: userB.avatarURL)
        v.addSubview(avatar)

        // 状态
        let stateView = StateView()
        v.addSubview(stateView)
        stateView.center = CGPoint(x: v.frame.width / 2, y: v.frame.width - stateView.frame.height / 2)
        stateView.setState(state.state)

        return v
    }
}

class DetailImageHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        createHead("瞬间")
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
        createHead("消息")
    }
}

class DetailMsgCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
    }
}



