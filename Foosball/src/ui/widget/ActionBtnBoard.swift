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
    init(t: String) {
        text = t
    }
}

class StateAction {
    let color: UIColor
    let lbtn: AcBtn
    var rbtn: AcBtn? = nil
    init(c: UIColor, l: AcBtn, r: AcBtn?) {
        color = c
        lbtn = l
        rbtn = r
    }
}

class ActionBtnBoard: UIView {

    private static let stateActionList: [EventState: StateAction] = [
        .invite: StateAction(c: UIColor.red,
            l: AcBtn(t: "加入"),
            r: AcBtn(t: "取消")),
        .ready: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .ongoing: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .waiting: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .win: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .lose: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .honoured: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .finish: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .impeach: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
        .keepImpeach: StateAction(c: UIColor.red,
            l: AcBtn(t: ""),
            r: AcBtn(t: "")),
    ]

    private let margin: CGFloat = 15
    private let topMargin: CGFloat = 3

    private var btnWidth: CGFloat = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 36))
    }

    // 根据不同的状态产生不同的按钮
    func setState(_ st: EventState) {
        let stateAct: StateAction = ActionBtnBoard.stateActionList[st]!

        // 计算按钮宽度
        btnWidth = frame.width - 2 * margin
        if stateAct.rbtn != nil {
            btnWidth = (btnWidth - margin) / 2
        }

        let lBtn = UIButton(type: .custom)
        addSubview(lBtn)
        lBtn.frame = CGRect(
            x: margin,
            y: topMargin,
            width: btnWidth,
            height: frame.height - 2 * topMargin
        )
        lBtn.setTitleColor(UIColor.white, for: .normal)
        lBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        lBtn.backgroundColor = BaseColor
        lBtn.layer.cornerRadius = 3

        lBtn.setTitle(stateAct.lbtn.text, for: .normal)
        
    }

    // 设置后会在右边出现聊天提示，并有气泡提示有多少条，如果小于等于0则消失
    func setMsgTip(_ num: Int) {

    }
}
