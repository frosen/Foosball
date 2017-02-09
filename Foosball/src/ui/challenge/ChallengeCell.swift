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
    private var VS: UILabel! = nil
    private var actionBtnBoard: ActionBtnBoard! = nil

    private var curEvent: Event! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return 108
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        // 因为原来自动的selectionStyle会让subview的backgroundcolor变成透明，所以把自动的关闭，自己写一个
        selectionStyle = .none

        //事件板
        eventBoard = EventBoard()
        contentView.addSubview(eventBoard)

        // 事件板中内容
        let teamView = eventBoard.contentView!

        VS = UILabel()
        teamView.addSubview(VS)

        VS.font = UIFont.boldSystemFont(ofSize: 15)
        VS.textColor = UIColor.black
        VS.textAlignment = .center
        VS.text = "VS"
        VS.sizeToFit()
        VS.center.y = teamView.frame.height / 2

        // 底部按钮
        actionBtnBoard = ActionBtnBoard(
            frame: CGRect(x: 0, y: 72, width: UIScreen.main.bounds.width, height: 36),
            vc: ctrlr,
            key: (ctrlr as! ChallengeController).DataObKey,
            delegate: self
        )
        contentView.addSubview(actionBtnBoard)
    }

    private let maxMemberCount: Int = 6
    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curEvent = e

        let urlStr: String? = e.imageURLList.count > 0 ? e.imageURLList[0] : nil
        eventBoard.setData(et: e.type, it: e.item, wager: e.wagerList, urlStr: urlStr)

        let st = UserMgr.getState(from: e, by: APP.userMgr.me.ID)
        eventBoard.set(state: st)

        // 加载team数据
        let teamView = eventBoard.contentView!
        let teamWidth = teamView.frame.height
        let interval: CGFloat = 18

        var memberPosX: CGFloat = 0

        var c: Int // 这个值来计算头像数量，一旦超过最大限度，就跳出
        c = 0
        for m in e.ourSideStateList {
            let v = createMemberView(m, avatarWidth: teamWidth, index: c)
            teamView.addSubview(v)

            v.frame.origin.x = memberPosX
            memberPosX += interval

            c += 1
            if c >= maxMemberCount {
                break
            }
        }

        VS.frame.origin.x = memberPosX + (teamWidth - interval) + 5 // 5是留白
        memberPosX = VS.frame.origin.x + VS.frame.width + 5

        let index = c // 保存上组的索引位置
        c = 0
        for m in e.opponentStateList {
            let v = createMemberView(m, avatarWidth: teamWidth, index: c + index)
            teamView.addSubview(v)

            v.frame.origin.x = memberPosX
            memberPosX += interval

            c += 1
            if c >= maxMemberCount {
                break
            }
        }

        handleUnusedAvatar(index + c)

        // 按钮
        actionBtnBoard.set(event: e)
        actionBtnBoard.set(state: st)

        if let change = APP.activeEventsMgr.eventChangeMap?[e.ID] {
            setTip(change.isStateChange, change.getMsgNumChange())
        }
    }

    private let avatarMargin: CGFloat = 3
    static private var avatarBGImg: UIImage? = nil
    private var avatarList: [UIView] = []
    private func createMemberView(_ user: UserState, avatarWidth: CGFloat, index: Int) -> UIView {
        if index >= avatarList.count {
            let w = avatarWidth - 2 * avatarMargin
            let avatar =  Avatar.create(
                rect: CGRect(x: 0, y: 0, width: w, height: w),
                name: user.user.name,
                url: user.user.avatarURL)

            if ChallengeCell.avatarBGImg == nil {
                // 这是一个白边，防止头像之间连在一起
                let avatarBGV = UIView(frame: CGRect(x: 0, y: 0, width: avatarWidth, height: avatarWidth))
                avatarBGV.backgroundColor = UIColor.white
                avatarBGV.layer.cornerRadius = avatarWidth / 2
                ChallengeCell.avatarBGImg = UITools.turnViewToImage(avatarBGV)
            }

            let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: avatarWidth, height: avatarWidth))
            bg.image = ChallengeCell.avatarBGImg
            bg.addSubview(avatar)
            avatar.center = bg.center

            avatarList.append(bg)
            
            return bg
        } else {
            let bg = avatarList[index]
            let avatar = bg.subviews[0] as! Avatar
            avatar.set(name: user.user.name, url: user.user.avatarURL)

            return bg
        }
    }

    private func handleUnusedAvatar(_ index: Int) {
        // 把没有用到的avatar，移到屏幕外
        for i in index ..< avatarList.count {
            avatarList[i].frame.origin.x = 99999
        }
    }

    // 提示
    func setTip(_ stateTip: Bool, _ msgNum: Int) {
        actionBtnBoard.setMsgTip(msgNum)
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

    func onExitEvent() {}
}
