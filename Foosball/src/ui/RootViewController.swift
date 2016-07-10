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

class RootViewController: UITabBarController {
    override func viewDidLoad() {
        initUI()
        initSubVc()
    }

    func initUI() {
        tabBar.tintColor = UIColor.redColor()

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

    func addVc(vc: UIViewController, title t: String, image img: String) {
        vc.tabBarItem.title = t

        // 设置子控制器的图片
        vc.tabBarItem.image = UIImage(named: img)

        // 先给外面传进来的小控制器 包装 一个导航控制器
        let nav = UINavigationController(rootViewController: vc)

        // 添加为子控制器
        addChildViewController(nav)
    }
}
