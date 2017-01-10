//
//  DetailTeamCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailTeamHeadCell: DetailHeadCell {
    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("队伍")
    }
}

// 一行6个头像，头像下面有状态
// 超过6个则换行
// 分成友方，敌方，观众
class DetailTeamCell: StaticCell {
    private static let memberCountIn1Line: CGFloat = 6
    private static let avatarMargin: CGFloat = 5
    private static let avatarTotalWidth: CGFloat = DetailG.widthWithoutMargin + 2 * avatarMargin
    private static let memberViewWidth: CGFloat = avatarTotalWidth / memberCountIn1Line
    private static let memberViewHeight: CGFloat = memberViewWidth + 27
    private static let teamBottomMargin: CGFloat = 4

    private var title: UILabel! = nil
    private var memberListView: UIView? = nil

    private var curEvent: Event! = nil
    private var curIndex: Int = 1 // 记录索引值，就可以知道是哪个team

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event?
        var avatarRowCount_float: CGFloat
        switch index!.row {
        case 1:
            avatarRowCount_float = CGFloat(e!.ourSideStateList.count + 1) / memberCountIn1Line // +1 是添加按钮
        case 2:
            avatarRowCount_float = CGFloat(e!.opponentStateList.count + 1) / memberCountIn1Line
        default:
            avatarRowCount_float = 0
        }
        let avatarRowCount = ceil(avatarRowCount_float)
        return avatarRowCount * memberViewHeight + DetailG.subTitleHeight + teamBottomMargin
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //图标题
        title = UILabel(frame: CGRect(x: DetailG.headMargin, y: 11, width: 300, height: 13))
        contentView.addSubview(title)

        title.font = TextFont
        title.textColor = SubTitleColor
        title.textAlignment = .left
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        // 读取数据
        let e: Event = d as! Event
        curEvent = e
        curIndex = index!.row

        let memberList: [UserState]
        var titleStr: String
        switch curIndex {
        case 1:
            memberList = e.ourSideStateList
            titleStr = "友方人员"
        case 2:
            memberList = e.opponentStateList
            titleStr = "对方人员"
        default:
            memberList = []
            titleStr = "观战者"
        }

        // 标题会显示人数
        let memberCount = memberList.count
        let countStr = " (" + String(memberCount) + ")"
        title.text = titleStr + countStr

        // 如果变了，就要清理掉原来的内容，并重建 todo 根据data是否变化而重新设置
        if memberListView != nil {
            memberListView!.removeFromSuperview()
        }
        let margin = DetailG.headMargin - DetailTeamCell.avatarMargin
        memberListView = UIView(frame: CGRect(x: margin, y: DetailG.subTitleHeight, width: 99999, height: 99999))
        contentView.addSubview(memberListView!)

        //设置member
        var pos: Int = 0
        var line: Int = 0
        for m in memberList {
            let v = createMemberView(m)
            memberListView!.addSubview(v)
            v.frame.origin.x = CGFloat(pos) * DetailTeamCell.memberViewWidth
            v.frame.origin.y = CGFloat(line) * DetailTeamCell.memberViewHeight

            pos += 1
            if pos >= Int(DetailTeamCell.memberCountIn1Line) {
                pos = 0
                line += 1
            }
        }

        let newBtn = createNewBtn()
        memberListView!.addSubview(newBtn)
        newBtn.frame.origin.x = CGFloat(pos) * DetailTeamCell.memberViewWidth
        newBtn.frame.origin.y = CGFloat(line) * DetailTeamCell.memberViewHeight

    }

    private func createMemberView(_ state: UserState) -> UIView {
        let userB = state.user
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: DetailTeamCell.memberViewWidth, height: DetailTeamCell.memberViewHeight)

        // 头像
        let avatarWidth = v.frame.width - 2 * DetailTeamCell.avatarMargin
        let avatar = Avatar.create(
            rect: CGRect(x: DetailTeamCell.avatarMargin, y: DetailTeamCell.avatarMargin, width: avatarWidth, height: avatarWidth),
            name: userB.name,
            url: userB.avatarURL)
        v.addSubview(avatar)

        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailTeamCell.tapAvatar(ges:)))
        avatar.addGestureRecognizer(tap)

        // 状态
        let stateView = StateView(small: true)
        v.addSubview(stateView)
        stateView.frame.origin = CGPoint(
            x: DetailTeamCell.avatarMargin,
            y: v.frame.width - DetailTeamCell.avatarMargin - stateView.frame.height
        )
        stateView.setState(state.state)

        // 名称
        let nameLbl = UILabel()
        v.addSubview(nameLbl)
        nameLbl.bounds = CGRect(x: 0, y: 0, width: avatarWidth, height: 14)
        nameLbl.center = CGPoint(x: DetailTeamCell.memberViewWidth / 2, y: DetailTeamCell.memberViewHeight - 19)
        nameLbl.font = UIFont.systemFont(ofSize: 11)
        nameLbl.textAlignment = .center
        nameLbl.textColor = SubTitleColor
        nameLbl.numberOfLines = 1
        nameLbl.lineBreakMode = .byTruncatingTail
        nameLbl.text = userB.name

        return v
    }

    private func createNewBtn() -> UIView {
        let v = UIView()
        v.bounds = CGRect(x: 0, y: 0, width: DetailTeamCell.memberViewWidth, height: DetailTeamCell.memberViewHeight)

        // 按钮
        let avatarWidth = v.frame.width - 2 * DetailTeamCell.avatarMargin
        let btn = UIButton(type: .custom)
        v.addSubview(btn)
        btn.frame = CGRect(x: DetailTeamCell.avatarMargin, y: DetailTeamCell.avatarMargin, width: avatarWidth, height: avatarWidth)
        btn.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        btn.backgroundColor = UIColor(white: 0.91, alpha: 1.0)
        btn.layer.cornerRadius =  avatarWidth / 2
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(DetailTeamCell.onClickInvite), for: .touchUpInside)

        // 文字
        let lbl = UILabel()
        v.addSubview(lbl)
        lbl.bounds = CGRect(x: 0, y: 0, width: avatarWidth, height: 14)
        lbl.center = CGPoint(x: DetailTeamCell.memberViewWidth / 2, y: DetailTeamCell.memberViewHeight - 19)
        lbl.font = UIFont.systemFont(ofSize: 11)
        lbl.textAlignment = .center
        lbl.textColor = SubTitleColor
        lbl.text = "邀请"

        return v
    }

    func tapAvatar(ges: UITapGestureRecognizer) {
        // todo
    }

    // 邀请
    func onClickInvite() {
        print("invite")

        // 判断是否可以邀请 todo
        if curEvent.createUserID != APP.userMgr.data.ID && curEvent.canInvite == false && curIndex != 3 {
            
        }
    
    }
}
