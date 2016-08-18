//
//  RootViewController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class RootViewController: UITabBarController, MyTabBarDelegate {
    var items: [UITabBarItem] = []

    var myTabBar: MyTabBar! = nil
    var tabBarYHide: CGFloat = 0 // tabbar隐藏时候的Y轴位置
    var tabBarYShow: CGFloat = 0

    override func viewDidLoad() {
        initUI()
        initSubVc()
        initTabBar()
    }

    func initUI() {
        let navBar = UINavigationBar.appearance()
        navBar.barTintColor = UIColor.redColor()
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

    func addVc(vc: BaseController, title t: String, image img: String) {
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
        vc.rootViewController = self
    }

    func initTabBar() {
        let midBtn = UIButton(type: .Custom)
        midBtn.setImage(UIImage(named: "mid_btn"), forState: .Normal)
        midBtn.setImage(UIImage(named: "mid_btn_press"), forState: .Highlighted)
        midBtn.sizeToFit()

        myTabBar = MyTabBar.replaceOldTabBar(self, midButton: midBtn, btnItems: items)
        myTabBar.myTabBarDelegate = self
        myTabBar.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        myTabBar.tintColor = UIColor.orangeColor()

        tabBarYShow = self.myTabBar.center.y
        tabBarYHide = tabBarYShow + 60
    }

    // MyTabBarDelegate
    func tabBar(tabBar: MyTabBar, didClickItem item: UIButton) {
        print("item", item.tag)
    }

    func tabBar(tabBar: MyTabBar, didClickMidButton btn: UIButton) {
        print("mid button")
    }

    //隐藏和显示tabbar
    func hideTabBar() {
        UIView.animateWithDuration(0.2, delay: 0.3, options: .CurveEaseIn, animations: {
            self.myTabBar.center.y = self.tabBarYHide
        }, completion: nil)
    }

    func showTabBar() {
        UIView.animateWithDuration(0.2, delay: 0.3, options: .CurveEaseOut, animations: {
            self.myTabBar.center.y = self.tabBarYShow
            }, completion: nil)
    }

}






