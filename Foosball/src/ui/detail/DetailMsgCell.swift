//
//  DetailMsgCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailMsgHeadCell: DetailHeadCell {
    var textInputView: InputView! = nil
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("消息")

        createButton("说话", color: UIColor.purple, pos: 0, callback: #selector(DetailMsgHeadCell.onClickSaying))

        textInputView = InputView()
        ctrlr.view.addSubview(textInputView)

        // 初始化时，y为总高是为了隐藏到最底下
        var inputFrame = textInputView.frame
        inputFrame.origin.y = UIScreen.main.bounds.height
        textInputView.frame = inputFrame

        NotificationCenter.default.addObserver(self, selector: #selector(DetailMsgHeadCell.keyboardWillShow), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailMsgHeadCell.keyBoardWillHide), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
    }

    func onClickSaying() {
        print("saying")
//        textInputView.beginInput()
    }

    func keyboardWillShow(note: Notification) {
        let userInfo = (note as NSNotification).userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let deltaY = keyBoardBounds.size.height

        let animations:(() -> Void) = {
            self.textInputView.transform = CGAffineTransform(translationX: 0, y: -deltaY - self.textInputView.frame.height)
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    func keyBoardWillHide(note: Notification) {
        let userInfo = (note as NSNotification).userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        let animations:(() -> Void) = {
            self.textInputView.transform = CGAffineTransform.identity
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
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

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        let msgStru: MsgStruct = e.msgList[index!.row - 1]
        return DetailG.calculateLblHeight(msgStru.msg, w: msgStrWidth) + DetailG.subTitleHeight + DetailG.contentBottomHeight
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
        let height = DetailG.calculateLblHeight(msgStru.msg, w: DetailMsgCell.msgStrWidth)
        txtLbl.frame = CGRect(x: DetailMsgCell.msgStrPosX, y: DetailG.subTitleHeight, width: DetailMsgCell.msgStrWidth, height: height)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        let attri: [String : Any] = [NSParagraphStyleAttributeName: paragraphStyle]
        let attriStr = NSAttributedString(string: msgStru.msg, attributes: attri)
        txtLbl.attributedText = attriStr
    }
}
