//
//  InputView.swift
//  Foosball
//
//  Created by luleyan on 16/10/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol InputViewDelegate {
    func onInputViewHeightReset()
}

class InputView: UIView, UITextViewDelegate {
    let w: CGFloat = UIScreen.main.bounds.width
    let h: CGFloat = 44
    let screenH: CGFloat = UIScreen.main.bounds.height

    let margin: CGFloat = 15
    let btnWidth: CGFloat = 50
    let btnHeight: CGFloat = 34
    let btnY: CGFloat = 5
    var inputWidth: CGFloat {
        return w - margin - (margin + btnWidth + margin)
    }

    static let inputFont: UIFont = UIFont.systemFont(ofSize: 18)
    static var lblStyleAttri: [String : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attri: [String : Any] = [
            NSFontAttributeName: inputFont,
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        return attri
    }

    var input: UITextView! = nil
    var endView: UIView! = nil
    var curInputHeight: CGFloat = 0
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: w, height: h))
        
        backgroundColor = UIColor(white: 0.96, alpha: 1.0)

        input = UITextView(frame: CGRect(x: margin, y: btnY, width: inputWidth, height: btnHeight))
        addSubview(input)
        input.delegate = self
        input.isScrollEnabled = false
        input.font = InputView.inputFont
        input.backgroundColor = UIColor.clear
        curInputHeight = btnHeight

        let headLine = UIView(frame: CGRect(x: 0, y: 0, width: w, height: 0.5))
        addSubview(headLine)
        headLine.backgroundColor = UIColor(white: 0.5, alpha: 1.0)

        let sendBtn = UIButton(frame: CGRect(x: w - margin - btnWidth, y: btnY, width: btnWidth, height: btnHeight))
        addSubview(sendBtn)

        sendBtn.backgroundColor = BaseColor
        sendBtn.setTitle("发送", for: .normal)
        sendBtn.layer.cornerRadius = 10

        let underLine = UIView(frame: CGRect(x: margin, y: btnHeight + btnY, width: inputWidth, height: 1))
        addSubview(underLine)
        underLine.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: InputViewDelegate? = nil

    func beginInput() {
        input.becomeFirstResponder()
    }

    func endInput() {
        input.resignFirstResponder()
    }

    func textViewDidChange(_ textView: UITextView) {
        let text = textView.text
        let h = DetailG.calculateLblHeight(text!, w: inputWidth - 10, style: InputView.lblStyleAttri)
        
        if h - curInputHeight > 1 { //+1为了防止float误差
            print("高度变化")
//            curInputHeight = max(btnY, h)

//            let oldFrame = frame
//            let newHeight = btnY + curInputHeight + btnY
//            frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: newHeight)
//
//            delegate?.onInputViewHeightReset()
        }
    }


}
