//
//  DetailMsgCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailMsgHeadCell: DetailHeadCell {
    private var isShowKeyboard: Bool = false

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应

        DetailMsgHeadCell.createMsgHeadView(
            contentView, s: (w, h),
            c: [
                (ctrlr, #selector(DetailViewController.beginInput)),
                (ctrlr, #selector(DetailViewController.beginInputScore))
            ]
        )
    }

    // 这么创建，是为了可以在外部创建统一的view
    class func createMsgHeadView(_ v: UIView, s: (CGFloat, CGFloat), c: [(Any, Selector)]) {
        DetailHeadCell.createHead(v, s: "消息", h: s.1)
        let posX = DetailMsgHeadCell.createButton(v, s: s, txt: "说话", fromPosX: 0, callback: c[0])
        let _ = DetailMsgHeadCell.createButton(v, s: s, txt: "记录比分", fromPosX: posX, callback: c[1])
    }

    class func createButton(_ v: UIView, s: (CGFloat, CGFloat), txt: String, fromPosX: CGFloat, callback: (Any, Selector)) -> CGFloat {
        let btn = UIButton(type: .system)
        v.addSubview(btn)

        let btnWidth: CGFloat = 15.0 * CGFloat(txt.characters.count) + 20.0
        btn.bounds = CGRect(x: 0, y: 0, width: btnWidth, height: 25)
        btn.center = CGPoint(x: s.0 - DetailG.headMargin - fromPosX - btnWidth / 2, y: s.1 / 2)

        btn.setTitle(txt, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = BaseColor
        btn.layer.cornerRadius = 9
        btn.addTarget(callback.0, action: callback.1, for: .touchUpInside)

        return btnWidth + DetailG.headMargin + fromPosX
    }
}

class DetailMsgCell: BaseCell {
    private static let msgAvatarWidth: CGFloat = 40
    private static let msgStrWidth: CGFloat = DetailG.widthWithoutMargin - msgAvatarWidth - DetailG.headMargin //这里的headMargin表示头像右边的空
    private static let msgStrPosX: CGFloat = DetailG.headMargin * 2 + msgAvatarWidth

    private var img: Avatar? = nil
    private var nameLbl: UILabel! = nil
    private var timeLbl: UILabel! = nil
    private var txtLbl: UILabel! = nil

    static var lblStyleAttri: [String : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        let attri: [String : Any] = [
            NSFontAttributeName: TextFont,
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        return attri
    }

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        let vc = otherData as! DetailViewController
        let section = index!.section
        let row = index!.row

        if let saveH = vc.cellHeightDict[vc.getCellHeightDictIndex(section: section, row: row)] {
            return saveH
        }

        let msgStru: MsgStruct = d as! MsgStruct
        return DetailG.calculateLblHeight(msgStru.msg, w: msgStrWidth, style: lblStyleAttri) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应

        // 创建名字和时间的文本
        nameLbl = UILabel()
        contentView.addSubview(nameLbl)
        nameLbl.font = TextFont
        nameLbl.textColor = SubTitleColor
        nameLbl.frame = CGRect(x: DetailMsgCell.msgStrPosX, y: 11, width: 150, height: 17)
        nameLbl.textAlignment = .left

        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = .byTruncatingTail // 行尾有超出用...

        timeLbl = UILabel()
        contentView.addSubview(timeLbl)
        timeLbl.font = TextFont
        timeLbl.textColor = SubTitleColor
        timeLbl.frame = CGRect(x: w - DetailG.headMargin - 100, y: 11, width: 100, height: 17)
        timeLbl.textAlignment = .right

        // 创建文本
        txtLbl = UILabel()
        contentView.addSubview(txtLbl)

        txtLbl.numberOfLines = 0
        txtLbl.lineBreakMode = .byCharWrapping
        txtLbl.font = TextFont

        // 长按效果
        let longP = UILongPressGestureRecognizer(target: self, action: #selector(DetailMsgCell.longPressCell(ges:)))
        contentView.addGestureRecognizer(longP)
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let msgStru: MsgStruct = d as! MsgStruct
        let user: User = msgStru.user!

        if img == nil {
            img = Avatar.create(
                rect: CGRect(x: DetailG.headMargin, y: DetailG.headMargin, width: DetailMsgCell.msgAvatarWidth, height: DetailMsgCell.msgAvatarWidth),
                name: user.name, url: user.avatarURL)
            contentView.addSubview(img!)

            let tap = UITapGestureRecognizer(target: self, action: #selector(DetailMsgCell.tapAvatar(ges:)))
            img!.addGestureRecognizer(tap)
        } else {
            img!.set(name: user.name, url: user.avatarURL)
        }

        //名字和时间
        nameLbl.text = (user.ID == APP.userMgr.me.ID) ? "自己" : user.name
        timeLbl.text = msgStru.time!.toString

        //文本
        let height = h - (DetailG.subTitleHeight + DetailG.contentBottomHeight) 
        txtLbl.frame = CGRect(x: DetailMsgCell.msgStrPosX, y: DetailG.subTitleHeight, width: DetailMsgCell.msgStrWidth, height: height)

        let attriStr = NSAttributedString(string: msgStru.msg, attributes: DetailMsgCell.lblStyleAttri)
        txtLbl.attributedText = attriStr
    }

    func longPressCell(ges: UILongPressGestureRecognizer) {
        if ges.state != .began {
            return
        }

        print("long press detail msg cell")

        // todo
    }

    func tapAvatar(ges: UITapGestureRecognizer) {
        // todo
    }
}

class DetailMsgTailCell: StaticCell {
    // 为了使msg head在最上，在尾部添加一个cell，使得高度等于tableview总高度，减去msg其他cell的高度
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        let vc = otherData as! DetailViewController
        let section = index!.section
        let row = index!.row

        if let saveH = vc.cellHeightDict[vc.getCellHeightDictIndex(section: section, row: row)] {
            return saveH
        }

        var totalMsgH: CGFloat = 0
        for i in 0 ..< row { // 本row之前其他msg高度之和
            totalMsgH += vc.cellHeightDict[vc.getCellHeightDictIndex(section: section, row: i)]!
        }

        let tableH = vc.tableView.frame.height - vc.tableView.contentInset.top - vc.tableView.contentInset.bottom
        let footerH = vc.tableView(vc.tableView, heightForFooterInSection: 3)
        let leftH = tableH - totalMsgH - footerH
        return max(leftH, 44 - footerH) // 最小44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        
    }
}









