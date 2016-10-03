//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

let headMargin: CGFloat = 12
let iconMargin: CGFloat = 6 //图标到边的距离

class DetailTitleCell: BaseCell {
    var title: UILabel! = nil
    var position: UILabel! = nil
    var createTime: UILabel! = nil

    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

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
        self.selectionStyle = .none //使选中后没有反应

        //底部分割线
        createDownLine()
    }
}

class DetailCashCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

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

    func createButton(_ txt: String, color: UIColor, pos: Int, callback: Selector) {
        let btn = UIButton(type: .system)
        contentView.addSubview(btn)

        btn.snp.makeConstraints{ make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(headMargin + CGFloat(pos) * 60)
            make.size.equalTo(CGSize(width: 50, height: 25))
        }

        btn.setTitle(txt, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = color
        btn.layer.cornerRadius = 9
        btn.addTarget(delegate, action: callback, for: .touchUpInside)
    }
}

// ==================================================================================================================

class DetailTeamHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        createHead("队伍")

        // 邀请按钮
        createButton("邀请", color: UIColor.purple, pos: 0, callback: #selector(DetailViewController.onClickInvite))

        //底线
        createDownLine()
    }

    func abc() {
        print("abc")
    }
}

// 一行6个头像，头像下面有状态
// 超过6个则换行
// 分成友方，敌方，观众
let widthWithoutMargin: CGFloat = UIScreen.main.bounds.width - 2 * headMargin

let memberCountIn1Line: CGFloat = 6
let avatarMargin: CGFloat = 3
let avatarTotalWidth: CGFloat = widthWithoutMargin + 2 * avatarMargin
let memberViewWidth: CGFloat = widthWithoutMargin / memberCountIn1Line
let memberViewHeight: CGFloat = memberViewWidth + 10
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
        self.selectionStyle = .none //使选中后没有反应

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
        v.bounds = CGRect(x: 0, y: 0, width: memberViewWidth, height: memberViewHeight)

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
        self.selectionStyle = .none //使选中后没有反应

        createHead("瞬间")
        createButton("拍照", color: UIColor.blue, pos: 0, callback: #selector(DetailViewController.onClickPhoto))
        createButton("图库", color: UIColor.red, pos: 1, callback: #selector(DetailViewController.onClickAlbum))
        createDownLine()
    }
}

let imageCountIn1Line: CGFloat = 4
let imgMargin: CGFloat = 2
let imageWidth: CGFloat = (widthWithoutMargin - 2 * imgMargin) / imageCountIn1Line
class DetailImageCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let lineCount = ceil(CGFloat(e.imageURLList.count) / imageCountIn1Line)
        return lineCount * imageWidth
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        let e = d as! Event
        let margin = headMargin - imgMargin
        var pos: Int = 0
        var line: Int = 0
        for imgUrl in e.imageURLList {
            let v = createImageView(url: imgUrl)
            contentView.addSubview(v)
            let f = v.frame
            v.frame = CGRect(
                x: CGFloat(pos) * f.width + margin,
                y: CGFloat(line) * f.height,
                width: f.width,
                height: f.height
            )

            pos += 1
            if pos >= Int(imageCountIn1Line) {
                pos = 0
                line += 1
            }
        }

    }

    func createImageView(url: String) -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: imageWidth, height: imageWidth)

        //添加图片
        let imgWidth = imageWidth - 2 * imgMargin
        let img = UIImageView(frame: CGRect(x: imgMargin, y: imgMargin, width: imgWidth, height: imgWidth))
        v.addSubview(img)

        img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "img_default"))

        return v
    }
}

class DetailMsgHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("消息")
    }
}

class DetailMsgCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
    }
}



