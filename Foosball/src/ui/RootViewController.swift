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
    var items: [UITabBarItem] = []

    var myTabBar: MyTabBar! = nil

    var currentCtrlr: BaseController! = nil

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
        nav.delegate = self

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
        myTabBar.tintColor = BaseColor
    }

    // MyTabBarDelegate
    func tabBar(_ tabBar: MyTabBar, didClickItem item: UIButton) {
        print("item", item.tag)
    }

    func tabBar(_ tabBar: MyTabBar, didClickMidButton btn: UIButton) {
        print("mid button")

        let createCtrlr = CreateController()
        createCtrlr.rootVC = self
        currentCtrlr.navigationController!.pushViewController(createCtrlr, animated: true)
    }

    // UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("aaa")
        return nil
    }
}

// 环状场景过渡
class RinglikeTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransType {
        case push
        case pop
    }

    var t: TransType! = nil
    init(t: TransType) {
        super.init()
        self.t = t
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (t == .push) {
            doPush(using: transitionContext)
        } else {
            doPop(using: transitionContext)
        }
    }

    func doPush(using transitionContext: UIViewControllerContextTransitioning) {

    }

    func doPop(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}







