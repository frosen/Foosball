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

    private var btnWidth: CGFloat = 0

    private var lBtn: UIButton! = nil
    private var rBtn: UIButton! = nil
    private var msgBtn: UIButton? = nil

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

        lBtn.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        lBtn.setTitleColor(UIColor.gray, for: .normal)
        lBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        lBtn.titleLabel!.font = font

        rBtn = UIButton(type: .custom)
        addSubview(rBtn)

        rBtn.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        rBtn.setTitleColor(UIColor.gray, for: .normal)
        rBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        rBtn.titleLabel!.font = font

        // msg按钮
        msgBtn = UIButton(type: .custom)
        msgBtn?.setImage(#imageLiteral(resourceName: "goto_msg").withRenderingMode(.alwaysTemplate), for: .normal)
    }

    // 根据不同的状态产生不同的按钮
    func setState(_ st: EventState) {
        let stateAct: StateAction = ActionBtnBoard.stateActionList[st]!

        // 计算按钮宽度
        btnWidth = frame.width - ((msgBtn != nil) ? msgBtn!.frame.width : CGFloat(0))
        btnWidth = btnWidth / ((stateAct.rbtn != nil) ? 2 : 1)

        if stateAct.lbtn == nil {
            lBtn.isHidden = true
        } else {
            lBtn.isHidden = false

            lBtn.frame.size.width = btnWidth
            lBtn.setImage(stateAct.lbtn!.img, for: .normal)
            lBtn.setTitle(stateAct.lbtn!.text, for: .normal)
        }

        if stateAct.rbtn == nil {
            rBtn.isHidden = true
        } else {
            rBtn.isHidden = false

            rBtn.frame.size.width = btnWidth
            rBtn.frame.origin.x = lBtn.frame.width + lBtn.frame.origin.x

            rBtn.setImage(stateAct.rbtn!.img, for: .normal)
            rBtn.setTitle(stateAct.rbtn!.text, for: .normal)
        }
    }

    func setStateTip(_ b: Bool) {
        
    }

    // 设置后会在右边出现聊天提示，并有气泡提示有多少条，如果小于等于0则消失
    func setMsgTip(_ num: Int) {

    }
}
