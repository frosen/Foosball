//
//  RootViewController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class RootViewController: UITabBarController, MyTabBarDelegate {
    var items: [UITabBarItem] = []

    var myTabBar: MyTabBar! = nil

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        initSubVc()
        initTabBar()
    }

    func initSubVc() {
        //挑战
        let challengeVc = ChallengeController()
        addVc(challengeVc, title: "挑战", image: "home2")

        //附近

        //创建

        //组队

        //个人
        let ownVc = OwnController()
        addVc(ownVc, title: "个人", image: "my2")
    }

    func addVc(_ vc: BaseTabController, title t: String, image img: String) {
        vc.tabBarItem.title = t

        // 设置子控制器的图片
        vc.tabBarItem.image = UIImage(named: img)

        // 先给外面传进来的小控制器 包装 一个导航控制器
        let nav = UINavigationController(rootViewController: vc)

        // 添加为子控制器
        addChildViewController(nav)

        //收集bar item 用于自定义的Tabbar
        items.append(vc.tabBarItem)

        // 让子控制器知道根控制器
        vc.rootVC = self
    }

    func initTabBar() {
        let midBtn = UIButton(type: .custom)
        midBtn.setImage(UIImage(named: "mid_btn"), for: UIControlState())
        midBtn.setImage(UIImage(named: "mid_btn_press"), for: .highlighted)
        midBtn.sizeToFit()

        myTabBar = MyTabBar.replaceOldTabBar(self, midButton: midBtn, btnItems: items)
        myTabBar.myTabBarDelegate = self
        myTabBar.tintColor = UIColor.orange
    }

    // MyTabBarDelegate
    func tabBar(_ tabBar: MyTabBar, didClickItem item: UIButton) {
        print("item", item.tag)
    }

    func tabBar(_ tabBar: MyTabBar, didClickMidButton btn: UIButton) {
        print("mid button")
    }
}






