//
//  EventBoard.swift
//  Foosball
//  事件信息展示板，用在多个cell中
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class EventIcon {
    class func create(_ h: CGFloat, iconMargin: CGFloat) -> (UIView, UIImageView) {
        //图标所在view，为布局而用
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: h, height: h))

        //图标
        let iconMargin: CGFloat = 6
        let iconWidth: CGFloat = h - iconMargin - iconMargin
        let icon = UIImageView(frame: CGRect(x: iconMargin, y: iconMargin, width: iconWidth, height: iconWidth))
        iconView.addSubview(icon)

        icon.layer.borderWidth = 3
        icon.layer.borderColor = UIColor.white.cgColor
//        icon.layer.shadowColor = UIColor.gray.cgColor
//        icon.layer.shadowOffset = CGSize(width: 1, height: 1)
//        icon.layer.shadowOpacity = 0.9
//        icon.layer.shadowRadius = 3

        icon.backgroundColor = BaseColor

        return (iconView, icon)
    }

    static let spaceHolder: UIImage = #imageLiteral(resourceName: "event_bg")
}

class EventBoard: UIView {

    var icon: UIImageView! = nil
    var title: UILabel! = nil
    var stateView: StateView! = nil
    var contentView: UIView! = nil //加载各个位置不同的控件

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        let w: CGFloat = UIScreen.main.bounds.width
        let h: CGFloat = 72
        super.init(frame: CGRect(x: 0, y: 0, width: w, height: h))

        backgroundColor = UIColor.white // 因为EventBoard会移动，在移动时候不显示下面的控件，所以不能透明

        let iconMargin: CGFloat = 6
        let (iconView, iconTmp) = EventIcon.create(h, iconMargin: iconMargin)
        addSubview(iconView)
        icon = iconTmp

        // 标题最右的状态指示
        stateView = StateView()
        addSubview(stateView)
        stateView.center = CGPoint(x: w - 15 - stateView.frame.width / 2, y: h * 0.3)

        //标题
        title = UILabel()
        addSubview(title)

        title.frame = CGRect(
            x: iconView.frame.width + 6,
            y: 0,
            width: w - (iconView.frame.width + 6 + (w - stateView.frame.origin.x) + 6),
            height: 25)
        title.center.y = h * 0.3

        title.font = TitleFont
        title.textColor = TitleColor

        // 内容位置
        contentView = UIView()
        addSubview(contentView)

        contentView.frame = CGRect(
            x: iconView.frame.width + 6,
            y: 0,
            width: w - (iconView.frame.width + 6 + iconMargin),
            height: 25)
        contentView.center.y = h * 0.7
    }

    func setData(et: EventType, it: ItemType, wager: [Wager], urlStr: String?) {
        // 图片
        let imgUrl = (urlStr != nil) ?
            URL(string: APP.activeEventsMgr.getImgUrlStr(from: urlStr!, useCut: true))! : getURLFromItemType(it)
        icon.sd_setImage(with: imgUrl, placeholderImage: EventIcon.spaceHolder)

        // 根据类型和奖杯组织一个题目
        title.text = createTitle(et: et, it: it, wager: wager)
    }

    func set(state: EventState) {
        stateView.setState(state)
    }

    private func getURLFromItemType(_ t: ItemType) -> URL {
        let s = "http://img02.tooopen.com/images/20131214/sy_51922633352.jpg"
        return URL(string: s)!
    }

    private func createTitle(et: EventType, it: ItemType, wager: [Wager]) -> String {
        return "这是一个很有意思的测试"
    }
}
