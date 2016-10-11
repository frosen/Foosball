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
let widthWithoutMargin: CGFloat = UIScreen.main.bounds.width - 2 * headMargin

class DetailTitleCell: StaticCell {
    var title: UILabel! = nil
    var position: UILabel! = nil
    var createTime: UILabel! = nil

    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

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

let subTitleHeight: CGFloat = 35
let contentBottomHeight: CGFloat = 12

let opt: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
func createParagraphStyle() -> NSMutableParagraphStyle {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 3
    paragraphStyle.headIndent = 12
    return paragraphStyle
}

func calculateLblHeight(_ s: String, w: CGFloat) -> CGFloat {
    let str = s as NSString
    let attri: [String : Any] = [
        NSFontAttributeName: TextFont,
        NSParagraphStyleAttributeName: createParagraphStyle()
    ]
    let size = str.boundingRect(with: CGSize(width: w, height: CGFloat(MAXFLOAT)), options: opt, attributes: attri, context: nil)
    return size.height
}

class DetailStringCell: StaticCell {
    var lbl: UILabel! = nil
    func initLblData(contentView: UIView, titleStr: String) {
        //标题
        let title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(headMargin)
        }
        title.font = TextFont
        title.textColor = SubTitleColor

        title.text = titleStr

        // 内容
        lbl = UILabel()
        contentView.addSubview(lbl)

        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byCharWrapping

        lbl.font = TextFont
    }

    func setLblData(contentView: UIView, str: String) {
        let height = calculateLblHeight(str, w: widthWithoutMargin)
        lbl.frame = CGRect(x: headMargin, y: subTitleHeight, width: widthWithoutMargin, height: height)
        let attri: [String : Any] = [NSParagraphStyleAttributeName: createParagraphStyle()]
        let attriStr = NSAttributedString(string: str, attributes: attri)
        lbl.attributedText = attriStr
    }
}

class DetailContentCell: DetailStringCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        return calculateLblHeight(e.detail, w: widthWithoutMargin) + subTitleHeight + contentBottomHeight
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "内容：")
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: e.detail)
    }
}

class DetailCashCell: DetailStringCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        return calculateLblHeight(e.award, w: widthWithoutMargin) + subTitleHeight + contentBottomHeight
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "奖杯：")
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: e.award)
    }
}

// =============================================================================================================

class DetailHeadCell: StaticCell {
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
    }
}

// 一行6个头像，头像下面有状态
// 超过6个则换行
// 分成友方，敌方，观众
let memberCountIn1Line: CGFloat = 6
let avatarMargin: CGFloat = 3
let avatarTotalWidth: CGFloat = widthWithoutMargin + 2 * avatarMargin
let memberViewWidth: CGFloat = avatarTotalWidth / memberCountIn1Line
let memberViewHeight: CGFloat = memberViewWidth + 10
let teamBottomMargin: CGFloat = 4
class DetailTeamCell: StaticCell {
    var title: UILabel! = nil
    var memberListView: UIView? = nil
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
        return avatarRowCount * memberViewHeight + subTitleHeight + teamBottomMargin
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //图标题
        title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(headMargin)
        }
        title.font = TextFont
        title.textColor = SubTitleColor
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        // 读取数据
        let e: Event = d as! Event
        let memberList: [UserState]
        var titleStr: String
        switch index!.row {
        case 1:
            memberList = e.ourSideStateList
            titleStr = "友方人员"
        case 2:
            memberList = e.opponentStateList
            titleStr = "对方人员"
        default:
            memberList = []
            titleStr = "观战者"
        }

        var countStr: String // 标题会显示人数
        let memberCount = memberList.count
        if memberCount > 0 {
            countStr = " (" + String(memberCount) + ")"
        } else {
            countStr = " ( 你的对手尚未就位，等待邀请 ) "
        }
        title.text = titleStr + countStr
        title.sizeToFit()

        // 如果变了，就要清理掉原来的内容，并重建 todo 根据data是否变化而重新设置
        if memberListView != nil {
            memberListView!.removeFromSuperview()
        }
        let margin = headMargin - avatarMargin
        memberListView = UIView(frame: CGRect(x: margin, y: subTitleHeight, width: 0, height: 0))
        contentView.addSubview(memberListView!)

        if memberCount == 0 { // 如果member为0则不用往下走了
            return
        }

        //设置member
        var pos: Int = 0
        var line: Int = 0
        for m in memberList {
            let v = createMemberView(m)
            memberListView!.addSubview(v)
            let f = v.frame
            v.frame = CGRect(
                x: CGFloat(pos) * f.width,
                y: CGFloat(line) * f.height,
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
        let avatar = Avatar.create(
            rect: CGRect(x: avatarMargin, y: avatarMargin, width: avatarWidth, height: avatarWidth),
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
    }
}

let imageCountIn1Line: CGFloat = 4
let imgMargin: CGFloat = 2
let imageViewWidth: CGFloat = (widthWithoutMargin + 2 * imgMargin) / imageCountIn1Line
let imgTopMargin: CGFloat = 4
let imgBottomMargin: CGFloat = 4
class DetailImageCell: StaticCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let lineCount = ceil(CGFloat(e.imageURLList.count) / imageCountIn1Line)
        return lineCount * imageViewWidth + imgTopMargin + imgBottomMargin
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        let e = d as! Event
        let margin = headMargin - imgMargin
        var pos: Int = 0
        var line: Int = 0
        var index: Int = 0
        for imgUrl in e.imageURLList {
            let v = createImageView(url: imgUrl, index: index)
            contentView.addSubview(v)
            let f = v.frame
            v.frame = CGRect(
                x: CGFloat(pos) * f.width + margin,
                y: CGFloat(line) * f.height + imgTopMargin,
                width: f.width,
                height: f.height
            )

            pos += 1
            if pos >= Int(imageCountIn1Line) {
                pos = 0
                line += 1
            }
            index += 1
        }
    }

    func createImageView(url: String, index: Int) -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewWidth)

        //添加图片
        let imgWidth = imageViewWidth - 2 * imgMargin
        let img = UIImageView(frame: CGRect(x: imgMargin, y: imgMargin, width: imgWidth, height: imgWidth))
        v.addSubview(img)

        img.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "img_default"))

        v.tag = index
        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailImageCell.tapImageView(tap:)))
        v.addGestureRecognizer(tap)

        return v
    }

    func tapImageView(tap: UITapGestureRecognizer) {
        let ctrller: DetailViewController = delegate as! DetailViewController
        ctrller.onClickImageView(tag: tap.view!.tag)
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

let msgAvatarWidth: CGFloat = 40
let msgStrWidth: CGFloat = widthWithoutMargin - msgAvatarWidth - headMargin //这里的headMargin表示头像右边的空
let msgStrPosX: CGFloat = headMargin * 2 + msgAvatarWidth
class DetailMsgCell: BaseCell {
    var img: Avatar? = nil
    var nameLbl: UILabel! = nil
    var timeLbl: UILabel! = nil
    var txtLbl: UILabel! = nil

    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let msgStru: MsgStruct = e.msgList[index!.row - 1]
        return calculateLblHeight(msgStru.msg, w: msgStrWidth) + subTitleHeight + contentBottomHeight
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //创建名字和时间的文本
        nameLbl = UILabel()
        contentView.addSubview(nameLbl)
        nameLbl.font = TextFont
        nameLbl.textColor = SubTitleColor
        nameLbl.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(msgStrPosX)
        }

        timeLbl = UILabel()
        contentView.addSubview(timeLbl)
        timeLbl.font = TextFont
        timeLbl.textColor = SubTitleColor
        timeLbl.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.right.equalTo(contentView.snp.right).inset(headMargin)
        }

        //创建文本
        txtLbl = UILabel()
        contentView.addSubview(txtLbl)

        txtLbl.numberOfLines = 0
        txtLbl.lineBreakMode = .byCharWrapping
        txtLbl.font = TextFont
    }

    override func setData(_ d: Data?, index: IndexPath?) {
        let curRow = index!.row

        let e = d as! Event
        let msgStru: MsgStruct = e.msgList[curRow - 1]
        let user: UserBrief = msgStru.user

        if img != nil {
            img!.removeFromSuperview()
        }
        img = Avatar.create(
            rect: CGRect(x: headMargin, y: headMargin, width: msgAvatarWidth, height: msgAvatarWidth),
            name: user.name, url: user.avatarURL)
        contentView.addSubview(img!)

        //名字和时间
        nameLbl.text = user.name
        nameLbl.sizeToFit()
        timeLbl.text = msgStru.time.toString()
        timeLbl.sizeToFit()

        //文本
        let height = calculateLblHeight(msgStru.msg, w: msgStrWidth)
        txtLbl.frame = CGRect(x: msgStrPosX, y: subTitleHeight, width: msgStrWidth, height: height)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attri: [String : Any] = [NSParagraphStyleAttributeName: paragraphStyle]
        let attriStr = NSAttributedString(string: msgStru.msg, attributes: attri)
        txtLbl.attributedText = attriStr
    }
}



