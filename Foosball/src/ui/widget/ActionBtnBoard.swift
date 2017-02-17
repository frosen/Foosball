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
    func onSendMsg()
    func onExitEvent()
}

class ActionBtnBoard: UIView {

    private static let stateActionList: [EventState: StateAction] = [
        .invite: StateAction(
            l: AcBtn(t: "加入活动"),
            r: AcBtn(t: "谢绝邀请")
        ),
        .overtime: StateAction(
            l: AcBtn(t: "关注比赛"),
            r: AcBtn(t: "退出活动")
        ),
        .watch: StateAction(
            l: AcBtn(t: "退出活动")
        ),
        .start: StateAction(
            l: AcBtn(t: "邀请朋友"),
            r: AcBtn(t: "退出活动")
        ),
        .ongoing: StateAction(
            l: AcBtn(t: "确认胜利"),
            r: AcBtn(t: "确认失败")
        ),
        .win: StateAction(
            l: AcBtn(t: "确认已兑现")
        ),
        .lose: StateAction(
            l: AcBtn(t: "完成兑现")
        ),
        .waitConfirm: StateAction(
            l: AcBtn(t: "等待其他人确认")
        ),
        .impeach: StateAction(
            l: AcBtn(t: "重新选择"),
            r: AcBtn(t: "保持质疑")
        ),
        .rechoose: StateAction(
            l: AcBtn(t: "确认胜利"),
            r: AcBtn(t: "确认失败")
        ),
        .finish_win: StateAction(
            l: AcBtn(t: "")
        ),
        .finish_lose: StateAction(
            l: AcBtn(t: "")
        ),
        .keepImpeach_win: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .keepImpeach_lose: StateAction(
            l: AcBtn(t: ""),
            r: AcBtn(t: "")
        ),
        .impeachEnd: StateAction(
            l: AcBtn(t: "完成")
        )
    ]

    private let margin: CGFloat = 15
    private let topMargin: CGFloat = 3

    private var lBtn: UIButton! = nil
    private var rBtn: UIButton! = nil
    private var msgBtn: UIButton? = nil

    private var curState: EventState = .start
    private var curMsgNum: Int = 0

    private var vc: UIViewController! = nil
    private var key: String = ""
    private var delegate: ActionBtnBoardDelegate! = nil
    private var event: Event? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect, vc: UIViewController, key: String, delegate: ActionBtnBoardDelegate) {
        super.init(frame: frame)

        self.vc = vc
        self.key = key
        self.delegate = delegate

        let font = UIFont.systemFont(ofSize: 12)

        lBtn = UIButton(type: .custom)
        addSubview(lBtn)

        lBtn.frame = CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height)
        lBtn.setTitleColor(UIColor.gray, for: .normal)
        lBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        lBtn.titleLabel!.font = font
        lBtn.addTarget(self, action: #selector(ActionBtnBoard.onClickLeftBtn), for: .touchUpInside)

        rBtn = UIButton(type: .custom)
        addSubview(rBtn)

        rBtn.frame = CGRect(x: 0, y: 0, width: frame.width / 3, height: frame.height)
        rBtn.setTitleColor(UIColor.gray, for: .normal)
        rBtn.setTitleColor(UIColor.lightGray, for: .highlighted)
        rBtn.titleLabel!.font = font
        rBtn.addTarget(self, action: #selector(ActionBtnBoard.onClickRightBtn), for: .touchUpInside)
    }

    func set(event: Event) {
        self.event = event
    }

    // 根据不同的状态产生不同的按钮
    func set(state: EventState) {
        curState = state

        let stateAct: StateAction = ActionBtnBoard.stateActionList[state]!

        lBtn.setImage(stateAct.lbtn!.img, for: .normal)
        lBtn.setTitle(stateAct.lbtn!.text, for: .normal)

        if stateAct.rbtn != nil {
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

        let numString = num <= 99 ? String(num) : ".."
        msgBtn!.setTitle(numString, for: .normal)
        curMsgNum = num
    }

    func onClickLeftBtn() {
        handleStateChange(curState, 1)
    }

    func onClickRightBtn() {
        handleStateChange(curState, 2)
    }

    func onClickGotoMsg() {
        delegate.onSendMsg()
    }

    // 改变状态 --------------------------------------------------

    private func handleStateChange(_ st: EventState, _ i: Int) {
        guard let e = event else {
            return
        }
        switch st {
        case .invite:
            if i == 1 { confirmInvite(e) } else { refuseInvite(e) }
        case .overtime:
            if i == 1 { watch(e) } else { exitEvent(e) }
        case .watch:
            if i == 1 { finishWin(e) } else { exitEvent(e) }
        case .start:
            if i == 1 { invite(e) } else { exitEvent(e) }
        case .ongoing:
            if i == 1 { win(e) } else { lose(e) }
        case .win:
            if i == 1 { finishWin(e) }
        case .lose:
            if i == 1 { finishLose(e) }
        case .waitConfirm:
            if i == 1 { sendMsg(e) }
        case .impeach:
            if i == 1 { keep(e) } else { rechoose(e) }
        case .rechoose:
            if i == 1 { win(e) } else { lose(e) }
        case .finish_win:
            if i == 1 { sendMsg(e) }
        case .finish_lose:
            if i == 1 { sendMsg(e) }
        case .keepImpeach_win:
            if i == 1 { sendMsg(e) } else { rechoose(e) }
        case .keepImpeach_lose:
            if i == 1 { sendMsg(e) } else { rechoose(e) }
        case .impeachEnd:
            if i == 1 { finishFromImpeach(e) }
        }
    }

    // ---------------------------------------------------------------------------------------------

    private func confirmInvite(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定参加这次活动吗？", type: 2, callback: { _ in
            APP.activeEventsMgr.changeState(to: .start, event: e, obKey: self.key, withChange: nil) { _ in }
        })
    }

    private func refuseInvite(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您不打算参加这次活动吗？", type: 2, callback: { _ in
            print("refuseInvite")
            APP.activeEventsMgr.exitEvent(event: e, obKey: self.key) { suc in
                if suc {
                    self.delegate.onExitEvent()
                }
            }
        })
    }

    // ---------------------------------------------------------------------------------------------

    private func watch(_ e: Event) {

    }

    private func exitEvent(_ e: Event) {
        UITools.showAlert(vc, title: "退出", msg: "您确定退出这次活动吗？", type: 2, callback: { _ in
            print("confirm to exit event")
            APP.activeEventsMgr.exitEvent(event: e, obKey: self.key) { suc in
                if suc {
                    self.delegate.onExitEvent()
                }
            }
        })
    }

    // ---------------------------------------------------------------------------------------------

    private func invite(_ e: Event) {

    }

    // ---------------------------------------------------------------------------------------------

    private func win(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定取得比赛胜利？", type: 2, callback: { _ in
            let changes = self.getChangeAttris(e)
            APP.activeEventsMgr.changeState(to: .win, event: e, obKey: self.key, withChange: changes) { suc in
                
            }
        })
    }

    private func lose(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定失利于这次比赛吗？", type: 2, callback: { _ in
            let changes = self.getChangeAttris(e)
            APP.activeEventsMgr.changeState(to: .lose, event: e, obKey: self.key, withChange: changes) { suc in

            }
        })
    }

    private func getChangeAttris(_ e: Event) -> [String: Any]? {
        if e.firstConfirmTime == nil {
            return [
                "ftm": Time.now.getTimeData(),
                "fid": APP.userMgr.me.ID.rawValue
            ]
        } else {
            return nil
        }
    }

    // ---------------------------------------------------------------------------------------------

    private func finishWin(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定已经获得奖杯，并完成这次比赛吗？（确认后不再有消息提示）", type: 2, callback: { _ in
            APP.activeEventsMgr.changeState(to: .finish_win, event: e, obKey: self.key, withChange: nil) { suc in
                if suc {
                    // todo 进入评价页面
                }
            }
        })
    }

    private func finishLose(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定已经兑现了约定，并完成这次比赛吗？（确认后不再有消息提示）", type: 2, callback: { _ in
            APP.activeEventsMgr.changeState(to: .finish_lose, event: e, obKey: self.key, withChange: nil) { suc in
                if suc {
                    // todo 进入评价页面
                }
            }
        })
    }

    // ---------------------------------------------------------------------------------------------

    private func sendMsg(_ e: Event) {
        self.delegate.onSendMsg()
    }

    // ---------------------------------------------------------------------------------------------

    private func keep(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定一直保持质疑的状态吗？（确认后不再有消息提示）", type: 2, callback: { _ in
            guard let usTup = e.eachUserState({ us -> Bool in
                return us.user.ID == APP.userMgr.me.ID
            }) else {
                return
            }

            let changeTo = self.getKeepState(usTup.0.state)
            APP.activeEventsMgr.changeState(to: changeTo, event: e, obKey: self.key, withChange: nil) { suc in
                if suc {
                    self.delegate.onExitEvent()
                }
            }
        })
    }

    private func getKeepState(_ st: EventState) -> EventState {
        switch st {
        case .win:
            return .keepImpeach_win
        case .lose:
            return .keepImpeach_lose
        default:
            print("ERROR: wrong state when to keep: ", st.rawValue)
            return .keepImpeach_win
        }
    }

    private func rechoose(_ e: Event) {
        UITools.showAlert(vc, title: nil, msg: "您确定参加这次活动吗？", type: 2, callback: { _ in
            APP.activeEventsMgr.changeState(to: .rechoose, event: e, obKey: self.key, withChange: nil) { _ in }
        })
    }

    // ---------------------------------------------------------------------------------------------

    private func finishFromImpeach(_ e: Event) {
        guard let usTup = e.eachUserState({ us -> Bool in
            return us.user.ID == APP.userMgr.me.ID
        }) else {
            return
        }

        let changeTo = getFinishState(usTup.0.state)
        APP.activeEventsMgr.changeState(to: changeTo, event: e, obKey: self.key, withChange: nil) { _ in }
    }

    private func getFinishState(_ st: EventState) -> EventState {
        switch st {
        case .keepImpeach_win:
            return .finish_win
        case .keepImpeach_lose:
            return .finish_lose
        default:
            print("ERROR: wrong state when to finish: ", st.rawValue)
            return .finish_win
        }
    }
}









