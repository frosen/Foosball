//
//  MyTabBar.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/4.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol MyTabBarDelegate {
    func tabBar(tabBar: MyTabBar, didClickItem item: UIButton)

    func tabBar(tabBar: MyTabBar, didClickMidButton btn: UIButton)
}

class MyTabBar: UIView {

    weak var ctrller: UITabBarController?
    var midButton: UIButton

    var buttons: [MyTabBarItem] = []
    weak var selectedButton: UIButton?

    var myTabBarDelegate: MyTabBarDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(vc: UITabBarController, midButton btn: UIButton) {
        ctrller = vc
        midButton = btn
        super.init(frame: vc.tabBar.frame)

        midButton.addTarget(self, action: #selector(MyTabBar.onClickMidBtn(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(midButton)

        backgroundColor = UIColor.whiteColor()
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
    }

    class func replaceOldTabBar(tabVc: UITabBarController, midButton btn: UIButton, btnItems items: [UITabBarItem]) -> MyTabBar {
        let tab = MyTabBar(vc: tabVc, midButton: btn)

        tabVc.view.insertSubview(tab, aboveSubview: tabVc.tabBar)
        tabVc.tabBar.removeFromSuperview()

        tab.setBarItems(items)

        return tab
    }

    func setBarItems(items: [UITabBarItem]) {
        //因为有中间按钮，所以items只能是两个或者4个
        assert(items.count == 2 || items.count == 4)

        for item in items {
            let btn = MyTabBarItem(type: .Custom)

            btn.setItem(item)

            btn.tag = buttons.count

            btn.addTarget(self, action: #selector(MyTabBar.onClickItem(_:)), forControlEvents: .TouchDown)

            addSubview(btn)
            buttons.append(btn)

            if btn.tag == 0 {
                onClickItem(btn)
            }
        }
        layoutBarItems()
    }

    func layoutBarItems() {
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
        midButton.center = CGPoint(x: vw * 0.5, y: 1.5 * vh - midButton.frame.size.height)
    }

    func onClickItem(btn: UIButton) {
        if btn.selected == true {
            return
        }

        selectedButton?.selected = false
        selectedButton = btn
        selectedButton!.selected = true

        ctrller!.selectedIndex = btn.tag

        myTabBarDelegate?.tabBar(self, didClickItem: btn)
    }

    func onClickMidBtn(btn: UIButton) {
        myTabBarDelegate?.tabBar(self, didClickMidButton: btn)
    }
}








