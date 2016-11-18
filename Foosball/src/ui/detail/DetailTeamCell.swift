//
//  DetailTeamCell.swift
//  Foosball
//
//  Created by luleyan on 16/10/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailTeamHeadCell: DetailHeadCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("队伍")
        let _ = createButton("邀请", fromPosX: 0, callback: #selector(DetailTeamHeadCell.onClickInvite)) // 邀请按钮
    }

    // 邀请
    func onClickInvite() {
        print("invite")
    }
}

// 一行6个头像，头像下面有状态
// 超过6个则换行
// 分成友方，敌方，观众
class DetailTeamCell: BaseCell {
    static let memberCountIn1Line: CGFloat = 6
    static let avatarMargin: CGFloat = 3
    static let avatarTotalWidth: CGFloat = DetailG.widthWithoutMargin + 2 * avatarMargin
    static let memberViewWidth: CGFloat = avatarTotalWidth / memberCountIn1Line
    static let memberViewHeight: CGFloat = memberViewWidth + 15
    static let teamBottomMargin: CGFloat = 4

    var title: UILabel! = nil
    var memberListView: UIView? = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event?
        var avatarRowRate: CGFloat
        switch index!.row {
        case 1:
            avatarRowRate = CGFloat(e!.ourSideStateList.count) / memberCountIn1Line
        case 2:
            avatarRowRate = CGFloat(e!.opponentStateList.count) / memberCountIn1Line
        default:
            avatarRowRate = 0
        }
        let avatarRowCount = ceil(avatarRowRate)
        return avatarRowCount * memberViewHeight + DetailG.subTitleHeight + teamBottomMargin
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //图标题
        title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(DetailG.headMargin)
        }
        title.font = TextFont
        title.textColor = SubTitleColor
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        // 读取数据
        let e: Event = d as! Event
        let memberList: [UserState]
        var titleStr: String
        switch index!.row {
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

        var countStr: String // 标题会显示人数
        let memberCount = memberList.count
        if memberCount > 0 {
            countStr = " (" + String(memberCount) + ")"
        } else {
            countStr = " ( 你的对手尚未就位，等待邀请 ) "
        }
        title.text = titleStr + countStr
        title.sizeToFit()

        // 如果变了，就要清理掉原来的内容，并重建 todo 根据data是否变化而重新设置
        if memberListView != nil {
            memberListView!.removeFromSuperview()
        }
        let margin = DetailG.headMargin - DetailTeamCell.avatarMargin
        memberListView = UIView(frame: CGRect(x: margin, y: DetailG.subTitleHeight, width: 99999, height: 99999))
        contentView.addSubview(memberListView!)

        if memberCount == 0 { // 如果member为0则不用往下走了
            return
        }

        //设置member
        var pos: Int = 0
        var line: Int = 0
        for m in memberList {
            let v = createMemberView(m)
            memberListView!.addSubview(v)
            v.frame.origin.x = CGFloat(pos) * v.frame.width
            v.frame.origin.y = CGFloat(line) * v.frame.height

            pos += 1
            if pos >= Int(DetailTeamCell.memberCountIn1Line) {
                pos = 0
                line += 1
            }
        }
    }

    func createMemberView(_ state: UserState) -> UIView {
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

        // 状态
        let stateView = StateView()
        v.addSubview(stateView)
        stateView.center = CGPoint(x: v.frame.width / 2, y: v.frame.width - stateView.frame.height / 2)
        stateView.setState(state.state)
        
        return v
    }
}
