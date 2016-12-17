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

class RootViewController: UITabBarController, MyTabBarDelegate, UINavigationControllerDelegate {
    private var items: [UITabBarItem] = []
    
    var myTabBar: MyTabBar! = nil
    var currentCtrlr: BaseController! = nil

    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        initNav()
        initSubVc()
        initTabBar() 
    }

    private func initNav() {
        let navBar = UINavigationBar.appearance()
        navBar.setBackgroundImage(UIImage(named: "nav_color"), for: .default)
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }

    private func initSubVc() {
        //挑战
        let challengeVc = ChallengeController(rootVC: self)
        addVc(challengeVc, title: "挑战", image: "home2")

        //附近

        //创建

        //组队

        //个人
        let ownVc = OwnController(rootVC: self)
        addVc(ownVc, title: "个人", image: "my2")
    }

    private func addVc(_ vc: BaseTabController, title t: String, image img: String) {
        vc.tabBarItem.title = t

        // 设置子控制器的图片
        vc.tabBarItem.image = UIImage(named: img)

        // 先给外面传进来的小控制器 包装 一个导航控制器
        let nav = UINavigationController(rootViewController: vc)
        nav.delegate = self

        // 添加为子控制器
        addChildViewController(nav)

        //收集bar item 用于自定义的Tabbar
        items.append(vc.tabBarItem)
    }

    private func initTabBar() {
        let midBtn = UIButton(type: .custom)
        midBtn.setImage(UIImage(named: "mid_btn"), for: UIControlState())
        midBtn.setImage(UIImage(named: "mid_btn_press"), for: .highlighted)
        midBtn.sizeToFit()

        myTabBar = MyTabBar.replaceOldTabBar(self, midButton: midBtn, btnItems: items)
        myTabBar.myTabBarDelegate = self
        myTabBar.tintColor = BaseColor
    }

    // MyTabBarDelegate
    func tabBar(_ tabBar: MyTabBar, didClickItem item: UIButton) {
        print("item", item.tag)
    }

    func tabBar(_ tabBar: MyTabBar, didClickMidButton btn: UIButton) {
        print("mid button")

        let createCtrlr = CreateController(rootVC: self)
        currentCtrlr.navigationController!.pushViewController(createCtrlr, animated: true) // 没有用模态跳转，是因为模态会在最上而挡住tabbar
    }

    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is BaseTabController && toVC is CreateController {
            return RinglikeTransitioning(t: .push)

        } else if fromVC is CreateController && toVC is BaseTabController {
            return RinglikeTransitioning(t: .pop)

        } else if fromVC is ChallengeController && toVC is DetailViewController {
            return KeynotelikeTransitioning(t: .push)

        } else if fromVC is DetailViewController && toVC is ChallengeController {
            return KeynotelikeTransitioning(t: .pop)

        } else {
            return nil
        }
    }
}








