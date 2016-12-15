//
//  MyTabBar.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/4.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol MyTabBarDelegate {
    func tabBar(_ tabBar: MyTabBar, didClickItem item: UIButton)

    func tabBar(_ tabBar: MyTabBar, didClickMidButton btn: UIButton)
}

class MyTabBar: UIView {

    static let midBtnCenterPosHeight: CGFloat = 33 //中间中心抬起的高度

    private weak var ctrller: UITabBarController?
    private var midButton: UIButton

    private var buttons: [MyTabBarItem] = []
    private weak var selectedButton: UIButton?

    var myTabBarDelegate: MyTabBarDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(vc: UITabBarController, midButton btn: UIButton) {
        ctrller = vc
        midButton = btn
        super.init(frame: vc.tabBar.frame)

        midButton.addTarget(self, action: #selector(MyTabBar.onClickMidBtn(_:)), for: .touchUpInside)
        self.addSubview(midButton)

        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
    }

    class func replaceOldTabBar(_ tabVc: UITabBarController, midButton btn: UIButton, btnItems items: [UITabBarItem]) -> MyTabBar {
        let tab = MyTabBar(vc: tabVc, midButton: btn)

        tabVc.view.insertSubview(tab, aboveSubview: tabVc.tabBar)
        tabVc.tabBar.removeFromSuperview()

        tab.setBarItems(items)

        return tab
    }

    private func setBarItems(_ items: [UITabBarItem]) {
        //因为有中间按钮，所以items只能是两个或者4个
        assert(items.count == 2 || items.count == 4)

        for item in items {
            let btn = MyTabBarItem(type: .custom)

            btn.setItem(item)

            btn.tag = buttons.count

            btn.addTarget(self, action: #selector(MyTabBar.onClickItem(_:)), for: .touchDown)

            addSubview(btn)
            buttons.append(btn)

            if btn.tag == 0 {
                onClickItem(btn)
            }
        }
        layoutBarItems()
    }

    private func layoutBarItems() {
        let midIndex = buttons.count == 2 ? 1 : 2

        let vw = bounds.size.width
        let vh = bounds.size.height

        var x: CGFloat = 0
        let y: CGFloat = 0
        let w = vw / CGFloat(buttons.count + 1)
        let h = vh

        var i = 0
        for btn in buttons {
            if (i == midIndex) {
                i += 1 //跳过中间位置
            }
            x = CGFloat(i) * w
            btn.frame = CGRect(x: x, y: y, width: w, height: h)

            i += 1
        }

        // 设置中央按钮的位置
        midButton.center = CGPoint(x: vw * 0.5, y: vh - MyTabBar.midBtnCenterPosHeight)
    }

    func onClickItem(_ btn: UIButton) {
        if btn.isSelected == true {
            return
        }

        selectedButton?.isSelected = false
        selectedButton = btn
        selectedButton!.isSelected = true

        ctrller!.selectedIndex = btn.tag

        myTabBarDelegate?.tabBar(self, didClickItem: btn)
    }

    func onClickMidBtn(_ btn: UIButton) {
        myTabBarDelegate?.tabBar(self, didClickMidButton: btn)
    }
}








