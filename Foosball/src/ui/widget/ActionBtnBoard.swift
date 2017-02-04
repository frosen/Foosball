//
//  ActionBtnBoard.swift
//  Foosball
//
//  Created by luleyan on 2016/12/29.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class AcBtn {
    let text: String
    let img: UIImage
    init(t: String, img: UIImage = #imageLiteral(resourceName: "act_btn_confirm")) {
        text = " " + t + " " // 与图标空开一点
        self.img = img
    }
}

class StateAction {
    var lbtn: AcBtn? = nil
    var rbtn: AcBtn? = nil
    init(l: AcBtn? = nil, r: AcBtn? = nil) {
        lbtn = l
        rbtn = r
    }
}

protocol ActionBtnBoardDelegate {
    func onPressMsg()
}

class ActionBtnBoard: UIView {

    private static let stateActionList: [EventState: StateAction] = [
        .invite: StateAction(
            l: AcBtn(t: "加入活动"),
            r: AcBtn(t: "谢绝邀请")
        ),
        .ready: StateAction(
            l: AcBtn(t: "邀请参加"),
            r: AcBtn(t: "退出活动")
        ),
        .ongoing: StateAction(
            l: AcBtn(t: "确认哈哈"),
            r: AcBtn(t: "确认呵呵")
        ),
        .waiting: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .win: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .lose: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .honoured: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .finish: StateAction(),
        .impeach: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .keepImpeach_win: StateAction(),
        .keepImpeach_lose: StateAction(),
    ]

    private let margin: CGFloat = 15
    private let topMargin: CGFloat = 3

    private var lBtn: UIButton! = nil
    private var rBtn: UIButton! = nil
    private var msgBtn: UIButton? = nil

    private var curMsgNum: Int = 0

    // 代理
    var delegate: ActionBtnBoardDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let font = UIFont.systemFont(ofSize: 12)

        lBtn = UIButton(type: .custom)
        addSubview(lBtn)

        lBtn.frame = CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height)
        lBtn.setTitleColor(UIColor.gray, for: .normal)
        lBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        lBtn.titleLabel!.font = font

        rBtn = UIButton(type: .custom)
        addSubview(rBtn)

        rBtn.frame = CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height)
        rBtn.setTitleColor(UIColor.gray, for: .normal)
        rBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        rBtn.titleLabel!.font = font
    }

    // 根据不同的状态产生不同的按钮
    func setState(_ st: EventState) {
        let stateAct: StateAction = ActionBtnBoard.stateActionList[st]!

        lBtn.setImage(stateAct.lbtn!.img, for: .normal)
        lBtn.setTitle(stateAct.lbtn!.text, for: .normal)

        if stateAct.lbtn != nil {
            rBtn.isHidden = false
            rBtn.setImage(stateAct.rbtn!.img, for: .normal)
            rBtn.setTitle(stateAct.rbtn!.text, for: .normal)

            lBtn.center.x = frame.width * 0.3
            rBtn.center.x = frame.width * 0.7
        } else {
            rBtn.isHidden = true
            lBtn.center.x = frame.width * 0.5
        }
    }

    // 设置后会在左边出现聊天提示，并有气泡提示有多少条，如果小于等于0则消失
    func setMsgTip(_ num: Int) {
        if msgBtn == nil {
            let h: CGFloat = 24
            msgBtn = UIButton(type: .custom)
            addSubview(msgBtn!)
            msgBtn!.frame = CGRect(x: frame.width + 5, y: 0, width: 60, height: h)
            msgBtn!.backgroundColor = UIColor.white

            msgBtn!.layer.cornerRadius = h / 2
            msgBtn!.layer.shadowColor = UIColor.gray.cgColor
            msgBtn!.layer.shadowOpacity = 0.3
            msgBtn!.layer.shadowRadius = 3
            msgBtn!.layer.shadowOffset = CGSize(width: -2, height: 1)

            msgBtn!.tintColor = BaseColor
            msgBtn!.setImage(#imageLiteral(resourceName: "goto_msg").withRenderingMode(.alwaysTemplate), for: .normal)
            msgBtn!.setTitleColor(TextColor, for: .normal)
            msgBtn!.titleLabel?.font = TextFont
            msgBtn!.imageEdgeInsets = UIEdgeInsets(top: 0, left: -17, bottom: 0, right: 0)
            msgBtn!.titleEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
            msgBtn!.addTarget(self, action: #selector(ActionBtnBoard.onClickGotoMsg), for: .touchUpInside)
        }

        if curMsgNum == 0 && num == 0 {
            return
        }

        if curMsgNum == 0 && num > 0 { // 进来
            UIView.animate(withDuration: 0.2, animations: {
                self.msgBtn!.frame.origin.x = self.frame.width - 60 + self.msgBtn!.frame.height / 2
            })
        } else if curMsgNum > 0 && num == 0 { // 出去
            UIView.animate(withDuration: 0.2, animations: {
                self.msgBtn!.frame.origin.x = self.frame.width + 5
            })
        }

        msgBtn!.setTitle(String(num), for: .normal)
        curMsgNum = num
    }

    func onClickGotoMsg() {
        delegate?.onPressMsg()
    }
}









