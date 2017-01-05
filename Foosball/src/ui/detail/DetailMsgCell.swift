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
        self.selectionStyle = .none //使选中后没有反应
        createHead("消息")

        let posX = createButton("说话", fromPosX: 0, callback: #selector(DetailMsgHeadCell.onClickSaying))
        let _ = createButton("记录比分", fromPosX: posX, callback: #selector(DetailMsgHeadCell.onClickScore))
    }

    func createButton(_ txt: String, fromPosX: CGFloat, callback: Selector) -> CGFloat {
        let btn = UIButton(type: .system)
        contentView.addSubview(btn)

        let btnWidth: CGFloat = 15.0 * CGFloat(txt.characters.count) + 20.0
        btn.bounds = CGRect(x: 0, y: 0, width: btnWidth, height: 25)
        btn.center = CGPoint(x: w - DetailG.headMargin - fromPosX - btnWidth / 2, y: h / 2)

        btn.setTitle(txt, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = BaseColor
        btn.layer.cornerRadius = 9
        btn.addTarget(self, action: callback, for: .touchUpInside)

        return btnWidth + DetailG.headMargin + fromPosX
    }

    func onClickSaying() {
        (ctrlr as! DetailViewController).beginInput()
    }

    func onClickScore() {
        // todo
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

    private var curEvent: Event! = nil
    private var curIndex: Int = 1

    static var lblStyleAttri: [String : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3

        let attri: [String : Any] = [
            NSFontAttributeName: TextFont,
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        return attri
    }

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let msgStru: MsgStruct = e.msgList[e.msgList.count - index!.row] // 倒过来显示的
        return DetailG.calculateLblHeight(msgStru.msg, w: msgStrWidth, style: lblStyleAttri) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

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
        let e = d as! Event
        curEvent = e
        curIndex = index!.row

        let msgStru: MsgStruct = e.msgList[e.msgList.count - curIndex] // 这里的减法是为了倒过来显示，时间靠后的放上面
        let user: UserBrief = msgStru.user

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
        nameLbl.text = user.name
        timeLbl.text = msgStru.time.toString

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
