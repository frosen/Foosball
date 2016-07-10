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

    private var buttons: [UIView] = []
    private var midButton: UIButton

    var myTabBarDelegate: MyTabBarDelegate? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(oldTabBar: UITabBar, midButton btn: UIButton) {
        midButton = btn
        super.init(frame: oldTabBar.frame)

        midButton.addTarget(self, action: "onClickMidBtn:", forControlEvents: .TouchUpInside)
        self.addSubview(midButton)
    }

    class func replaceOldTabBar(tabVc: UITabBarController, midButton btn: UIButton) -> MyTabBar {
        let tab = MyTabBar(oldTabBar: tabVc.tabBar, midButton: btn)

        tabVc.view.insertSubview(tab, aboveSubview: tabVc.tabBar)
        tabVc.tabBar.removeFromSuperview()

        return tab
    }

    func setBarItems(items: [UITabBarItem]) {
        for item in items {
            let btn = UIButton(type: .Custom)

            btn.tag = buttons.count
            btn.addTarget(self, action: "onClickBtn:", forControlEvents: .TouchDown)

            addSubview(btn)
            buttons.append(btn)

            if btn.tag == 0 {
                onClickBtn(btn)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let vw = bounds.size.width
        let vh = bounds.size.height

        var x: CGFloat = 0
        let y: CGFloat = 0
        let w = vw / CGFloat(buttons.count + 1)
        let h = vh

        var i = 0
        for view in buttons {
            if (i == 2) {
                i = 3
            }
            x = CGFloat(i) * w
            view.frame = CGRect(x: x, y: y, width: w, height: h)
            i += 1
        }
    }

    func onClickBtn(btn: UIButton) {

    }

    func onClickMidBtn(btn: UIButton) {

    }
}








