//
//  Transitioning.swift
//  Foosball
//
//  Created by luleyan on 2016/11/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

// 环状场景过渡
// 参考：http://www.jianshu.com/p/45434f73019e    http://www.jianshu.com/p/8c29fce5a994
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
        let (beginFrame, endFrame) = calculatePos(v: toVC.baseView)

        let circleMaskPathInitial = UIBezierPath(ovalIn: beginFrame)
        let circleMaskPathFinal = UIBezierPath(ovalIn: endFrame)

        // 创建蒙版
        // 一个关于动画的文章 http://www.cocoachina.com/ios/20161202/18252.html
        let maskLayer = CAShapeLayer()
        maskLayer.path = circleMaskPathFinal.cgPath
        toVC.view.layer.mask = maskLayer

        // 蒙版动画
        let maskLayerAnim = CABasicAnimation(keyPath: "path")
        maskLayerAnim.fromValue = circleMaskPathInitial.cgPath
        maskLayerAnim.toValue = circleMaskPathFinal.cgPath
        maskLayerAnim.duration = self.transitionDuration(using: transitionContext)
        maskLayerAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        maskLayerAnim.delegate = self
        maskLayer.add(maskLayerAnim, forKey: "path")
    }

    func doPop(using transitionContext: UIViewControllerContextTransitioning) {
        print("do self pop")

        self.transitionContext = transitionContext

        let fromVC = transitionContext.viewController(forKey: .from)! as! BaseController
        let toVC = transitionContext.viewController(forKey: .to)! as! BaseController

        transitionContext.containerView.addSubview(toVC.view)
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
        let beginPos = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: v.frame.height - MyTabBar.midBtnCenterPosHeight - 64 //由于透明化了nav，所以把这段距离减去
        )
        let beginSize: CGFloat = 10
        let beginFrame = CGRect(x: beginPos.x - beginSize / 2, y: beginPos.y - beginSize / 2, width: beginSize, height: beginSize)

        let endRadius = sqrt(beginPos.x * beginPos.x + (beginPos.y + 64) * (beginPos.y + 64))
        let endFrame = beginFrame.insetBy(dx: -endRadius, dy: -endRadius)
        
        return (beginFrame, endFrame)
    }
}

// 像keynote一样的转景方式 用于Changenge场景
// 参考：http://www.jianshu.com/p/38cd35968864
class KeynotelikeTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    enum TransType {
        case push
        case pop
    }

    // 记录转景信息，用于pop
    static weak var snapshot: UIView! = nil
    static var originPosY: CGFloat = 0
    static var originView: UIView! = nil

    // 在场景中调用
    class func hideSnapshot() {
        UIView.animate(withDuration: 0.2) {
            snapshot.alpha = 0
        }
    }

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
        print("do keynote lick push")

        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: .from)! as! ChallengeController
        let toVC = transitionContext.viewController(forKey: .to)! as! DetailViewController
        let container = transitionContext.containerView

        //2.创建一个 Cell 中 imageView 的截图，并把 imageView 隐藏，造成使用户以为移动的就是 imageView 的假象
        let selectedView = fromVC.selectedCell!.eventBoard!
        let snapshotView = selectedView.snapshotView(afterScreenUpdates: false)!
        snapshotView.frame = container.convert(selectedView.frame, from: fromVC.selectedCell!.contentView)
        selectedView.isHidden = true

        //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
        toVC.view.frame = transitionContext.finalFrame(for: toVC)
        toVC.view.alpha = 0

        //4.都添加到 container 中。注意顺序不能错了
        container.addSubview(toVC.view)
        container.addSubview(snapshotView)

        //5.记录到静态属性中，用于pop
        KeynotelikeTransitioning.snapshot = snapshotView
        KeynotelikeTransitioning.originPosY = snapshotView.frame.origin.y
        KeynotelikeTransitioning.originView = selectedView

        //6.执行动画
        let t = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: t, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { _ in
            snapshotView.frame.origin.y = 64
            toVC.view.alpha = 1
        }, completion: { _ in
            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        })
    }

    func doPop(using transitionContext: UIViewControllerContextTransitioning) {
        print("do keynote lick pop")

        //1.获取动画的源控制器和目标控制器
        let fromVC = transitionContext.viewController(forKey: .from)! as! DetailViewController
        let toVC = transitionContext.viewController(forKey: .to)! as! ChallengeController
        let container = transitionContext.containerView

        let snapshotView = KeynotelikeTransitioning.snapshot!
        snapshotView.alpha = 1

        // snapshot初始位置计算
        let offsetY = min(fromVC.tableView.contentOffset.y, 100)
        snapshotView.frame.origin.y -= offsetY

        // 添加到转景容器中
        container.addSubview(toVC.view)
        container.addSubview(fromVC.view)
        container.addSubview(snapshotView)

        //执行动画
        let t = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: t, delay: 0, options: .curveEaseInOut, animations: { _ in
            snapshotView.frame.origin.y = KeynotelikeTransitioning.originPosY
            fromVC.view.alpha = 0
            toVC.view.alpha = 1
        }, completion: { _ in
            snapshotView.removeFromSuperview()
            KeynotelikeTransitioning.originView.isHidden = false

            //一定要记得动画完成后执行此方法，让系统管理 navigation
            transitionContext.completeTransition(true)
        })
    }
}





