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
    init(t: String, imgStr: String = "act_btn_confirm") {
        text = " " + t + " " // 与图标空开一点
        img = UIImage(named: imgStr)!
    }
}

class StateAction {
    let lbtn: AcBtn
    var rbtn: AcBtn? = nil
    init(l: AcBtn, r: AcBtn?) {
        lbtn = l
        rbtn = r
    }
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
        .finish: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .impeach: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .keepImpeach: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
    ]

    private let margin: CGFloat = 15
    private let topMargin: CGFloat = 3

    private var btnWidth: CGFloat = 0

    private var lBtn: UIButton! = nil
    private var rBtn: UIButton! = nil
    private var msgBtn: UIButton? = nil

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
        lBtn.titleLabel!.font = font

        rBtn = UIButton(type: .custom)
        addSubview(rBtn)

        rBtn.frame = CGRect(x: 0, y: 0, width: 0, height: frame.height)
        rBtn.setTitleColor(UIColor.gray, for: .normal)
        rBtn.titleLabel!.font = font
    }

    // 根据不同的状态产生不同的按钮
    func setState(_ st: EventState) {
        let stateAct: StateAction = ActionBtnBoard.stateActionList[st]!

        // 计算按钮宽度
        btnWidth = frame.width - ((msgBtn != nil) ? msgBtn!.frame.width : CGFloat(0))
        btnWidth = btnWidth / ((stateAct.rbtn != nil) ? 2 : 1)

        lBtn.frame.size.width = btnWidth
        lBtn.setImage(stateAct.lbtn.img, for: .normal)
        lBtn.setTitle(stateAct.lbtn.text, for: .normal)

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

    // 设置后会在右边出现聊天提示，并有气泡提示有多少条，如果小于等于0则消失
    func setMsgTip(_ num: Int) {

    }
}
