//
//  ChallengeCell.swift
//  Foosball
//  分两部分组成，event board 和下面的按钮排
//  Created by 卢乐颜 on 16/8/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeCell: BaseCell, ActionBtnBoardDelegate {
    var eventBoard: EventBoard! = nil
    private var actionBtnBoard: ActionBtnBoard! = nil

    private var curEvent: Event! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 108
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        // 因为原来自动的selectionStyle会让subview的backgroundcolor变成透明，所以把自动的关闭，自己写一个
        selectionStyle = .none

        //事件板
        eventBoard = EventBoard()
        contentView.addSubview(eventBoard)

        // 底部按钮
        actionBtnBoard = ActionBtnBoard(frame: CGRect(x: 0, y: 72, width: UIScreen.main.bounds.width, height: 36))
        contentView.addSubview(actionBtnBoard)
        actionBtnBoard.delegate = self
    }

    let maxMemberCount: Int = 6
    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curEvent = e

        eventBoard.setData(et: e.type, it: e.item, wager: e.wager)

        let st = APP.userMgr.getState(from: e, by: APP.userMgr.data.ID)
        eventBoard.set(state: st)

        // 加载team数据
        let teamView = eventBoard.contentView!
        for item in teamView.subviews {
            item.removeFromSuperview()
        }

        // 中间的vs字样
        let VS = UILabel()
        teamView.addSubview(VS)

        VS.font = UIFont.boldSystemFont(ofSize: 15)
        VS.textColor = UIColor.black
        VS.textAlignment = .center
        VS.text = "VS"
        VS.sizeToFit()

        let teamWidth = teamView.frame.height
        let interval: CGFloat = 18

        var memberPosX: CGFloat = 0

        var c: Int // 这个值来计算头像数量，一旦超过最大限度，就跳出
        c = 0
        for m in e.ourSideStateList {
            let v = createMemberView(m, avatarWidth: teamWidth)
            teamView.addSubview(v)
            v.frame.origin.x = memberPosX
            memberPosX += interval

            c += 1
            if c >= maxMemberCount {
                break
            }
        }

        VS.center.y = teamView.frame.height / 2
        VS.frame.origin.x = memberPosX + (teamWidth - interval) + 5 // 5是留白
        memberPosX = VS.frame.origin.x + VS.frame.width + 5

        c = 0
        for m in e.opponentStateList {
            let v = createMemberView(m, avatarWidth: teamWidth)
            teamView.addSubview(v)
            v.frame.origin.x = memberPosX
            memberPosX += interval

            c += 1
            if c >= maxMemberCount {
                break
            }
        }

        // 按钮
        actionBtnBoard.setState(st)

        if let changeTup: (Bool, Int) = APP.activeEventsMgr.eventChangeMap[e] {
            actionBtnBoard.setStateTip(changeTup.0)
            actionBtnBoard.setMsgTip(changeTup.1)
        }
    }

    private let avatarMargin: CGFloat = 3
    private func createMemberView(_ user: UserState, avatarWidth: CGFloat) -> UIView {
        let w = avatarWidth - 2 * avatarMargin
        let avatar =  Avatar.create(
            rect: CGRect(x: 0, y: 0, width: w, height: w),
            name: user.user.name,
            url: user.user.avatarURL)

        // 这是一个白边，防止头像之间连在一起
        let avatarBG = UIView(frame: CGRect(x: 0, y: 0, width: avatarWidth, height: avatarWidth))
        avatarBG.backgroundColor = UIColor.white

        avatarBG.layer.cornerRadius = avatarWidth / 2

        avatarBG.addSubview(avatar)
        avatar.center = avatarBG.center

        return avatarBG
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        } else {
            backgroundColor = UIColor.white
        }
    }

    // ActionBtnBoardDelegate --------------------------------------------------------------

    func onPressMsg() {
        let vc = ctrlr as! ChallengeController
        vc.enterDetail(cell: self, id: curEvent.ID, showMsg: true)
    }
}
