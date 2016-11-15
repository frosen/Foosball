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
        if toVC is CreateController {
            return RinglikeTransitioning(t: .push)
        } else if fromVC is CreateController {
            return RinglikeTransitioning(t: .pop)
        } else {
            return nil
        }
    }
}

// 环状场景过渡
class RinglikeTransitioning: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    enum TransType {
        case push
        case pop
    }

    weak var transitionContext: UIViewControllerContextTransitioning?

    var t: TransType! = nil
    init(t: TransType) {
        super.init()
        self.t = t
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if (t == .push) {
            doPush(using: transitionContext)
        } else {
            doPop(using: transitionContext)
        }
    }

    func doPush(using transitionContext: UIViewControllerContextTransitioning) {
        print("do self push")

        self.transitionContext = transitionContext

        let toVC = transitionContext.viewController(forKey: .to)! as! BaseController
        transitionContext.containerView.addSubview(toVC.view)

        // 计算位置
        let beginPos = CGPoint(x: UIScreen.main.bounds.width / 2, y: toVC.baseView.frame.height - MyTabBar.midBtnCenterPosHeight)
        let beginSize: CGFloat = 10
        let beginFrame = CGRect(x: beginPos.x - beginSize / 2, y: beginPos.y - beginSize / 2, width: beginSize, height: beginSize)

        let endRadius = sqrt(beginPos.x * beginPos.x + beginPos.y * beginPos.y)
        let endFrame = beginFrame.insetBy(dx: -endRadius, dy: -endRadius)

        let circleMaskPathInitial = UIBezierPath(ovalIn: beginFrame)
        let circleMaskPathFinal = UIBezierPath(ovalIn: endFrame)

        // 创建蒙版
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toVC.view.layer.mask = maskLayer

        // 蒙版动画
        let maskLayerAnim = CABasicAnimation(keyPath: "path")
        maskLayerAnim.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnim.toValue = circleMaskPathFinal.cgPath
        maskLayerAnim.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        maskLayerAnim.delegate = self
        maskLayer.add(maskLayerAnim, forKey: "path")
    }

    func doPop(using transitionContext: UIViewControllerContextTransitioning) {
        print("do self pop")

        self.transitionContext = transitionContext

        let fromVC = transitionContext.viewController(forKey: .from)! as! BaseController
        transitionContext.containerView.addSubview(fromVC.view)

        // 计算位置
        let (beginFrame, endFrame) = calculatePos(v: fromVC.baseView)

        let circleMaskPathInitial = UIBezierPath(ovalIn: endFrame)
        let circleMaskPathFinal = UIBezierPath(ovalIn: beginFrame)

        // 创建蒙版
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        fromVC.view.layer.mask = maskLayer

        // 蒙版动画
        let maskLayerAnim = CABasicAnimation(keyPath: "path")
        maskLayerAnim.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnim.toValue = circleMaskPathFinal.cgPath
        maskLayerAnim.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnim.delegate = self
        maskLayer.add(maskLayerAnim, forKey: "path")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
        self.transitionContext?.viewController(forKey: .from)?.view.layer.mask = nil
    }

    func calculatePos(v: UIView) -> (CGRect, CGRect) {
        let beginPos = CGPoint(x: UIScreen.main.bounds.width / 2, y: v.frame.height - MyTabBar.midBtnCenterPosHeight)
        let beginSize: CGFloat = 10
        let beginFrame = CGRect(x: beginPos.x - beginSize / 2, y: beginPos.y - beginSize / 2, width: beginSize, height: beginSize)

        let endRadius = sqrt(beginPos.x * beginPos.x + beginPos.y * beginPos.y)
        let endFrame = beginFrame.insetBy(dx: -endRadius, dy: -endRadius)

        return (beginFrame, endFrame)
    }
}







