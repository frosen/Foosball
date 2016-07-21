//
//  MyTabBar.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/4.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol MyTabBarDelegate {

}

class MyTabBar: UIView {

    private var buttons: [MyTabBarItem] = []
    private var midButton: UIButton

    var myTabBarDelegate: MyTabBarDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(oldTabBar: UITabBar, midButton btn: UIButton) {
        midButton = btn
        super.init(frame: oldTabBar.frame)

        midButton.addTarget(self, action: #selector(MyTabBar.onClickMidBtn(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(midButton)
    }

    class func replaceOldTabBar(tabVc: UITabBarController, midButton btn: UIButton, btnItems items: [UITabBarItem]) -> MyTabBar {
        let tab = MyTabBar(oldTabBar: tabVc.tabBar, midButton: btn)

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
            btn.layout()
            i += 1
        }

        // 设置中央按钮的位置
        midButton.center = CGPoint(x: vw * 0.5, y: 1.5 * vh - midButton.frame.size.height)
        print(midButton.frame)
    }

    func onClickItem(btn: UIButton) {

    }

    func onClickMidBtn(btn: UIButton) {

    }
}








