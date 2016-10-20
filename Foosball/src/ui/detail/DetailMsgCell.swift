//
//  DetailMsgCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailMsgHeadCell: DetailHeadCell {
    var isShowKeyboard: Bool = false
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("消息")

        createButton("说话", color: UIColor.purple, pos: 0, callback: #selector(DetailMsgHeadCell.onClickSaying))
    }

    func onClickSaying() {
        (ctrlr as! DetailViewController).beginInput()
    }
}

class DetailMsgCell: BaseCell {
    static let msgAvatarWidth: CGFloat = 40
    static let msgStrWidth: CGFloat = DetailG.widthWithoutMargin - msgAvatarWidth - DetailG.headMargin //这里的headMargin表示头像右边的空
    static let msgStrPosX: CGFloat = DetailG.headMargin * 2 + msgAvatarWidth

    var img: Avatar? = nil
    var nameLbl: UILabel! = nil
    var timeLbl: UILabel! = nil
    var txtLbl: UILabel! = nil

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
        let msgStru: MsgStruct = e.msgList[index!.row - 1]
        return DetailG.calculateLblHeight(msgStru.msg, w: msgStrWidth, style: lblStyleAttri) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //创建名字和时间的文本
        nameLbl = UILabel()
        contentView.addSubview(nameLbl)
        nameLbl.font = TextFont
        nameLbl.textColor = SubTitleColor
        nameLbl.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(DetailMsgCell.msgStrPosX)
        }

        timeLbl = UILabel()
        contentView.addSubview(timeLbl)
        timeLbl.font = TextFont
        timeLbl.textColor = SubTitleColor
        timeLbl.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.right.equalTo(contentView.snp.right).inset(DetailG.headMargin)
        }

        //创建文本
        txtLbl = UILabel()
        contentView.addSubview(txtLbl)

        txtLbl.numberOfLines = 0
        txtLbl.lineBreakMode = .byCharWrapping
        txtLbl.font = TextFont
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let curRow = index!.row

        let e = d as! Event
        let msgStru: MsgStruct = e.msgList[curRow - 1]
        let user: UserBrief = msgStru.user

        if img != nil {
            img!.removeFromSuperview()
        }
        img = Avatar.create(
            rect: CGRect(x: DetailG.headMargin, y: DetailG.headMargin, width: DetailMsgCell.msgAvatarWidth, height: DetailMsgCell.msgAvatarWidth),
            name: user.name, url: user.avatarURL)
        contentView.addSubview(img!)

        //名字和时间
        nameLbl.text = user.name
        nameLbl.sizeToFit()
        timeLbl.text = msgStru.time.toString()
        timeLbl.sizeToFit()

        //文本
        let height = DetailG.calculateLblHeight(msgStru.msg, w: DetailMsgCell.msgStrWidth, style: DetailMsgCell.lblStyleAttri)
        txtLbl.frame = CGRect(x: DetailMsgCell.msgStrPosX, y: DetailG.subTitleHeight, width: DetailMsgCell.msgStrWidth, height: height)

        let attriStr = NSAttributedString(string: msgStru.msg, attributes: DetailMsgCell.lblStyleAttri)
        txtLbl.attributedText = attriStr
    }
}
