//
//  BaseController.swift
//  Foosball
//  控制器基类
//  1. 对加载data的位置进行控制
//  2. 对导航栏和tabbar进行控制
//  Created by 卢乐颜 on 16/8/19.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

struct NavTabType: OptionSet {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }

    static let None = NavTabType(rawValue: 0)

    static let TransparentNav = NavTabType(rawValue: 1)
    static let HideTab = NavTabType(rawValue: 2)
}

class BaseController: UIViewController {

    var rootVC: RootViewController //根控制器
    var navTabType: NavTabType = .None

    var initDataOnViewAppear: Bool = false
    private var hasInitData: Bool = false
    var baseView: UIView! = nil

    static var isLastTabbarHide = false // 上个页面是否显示了tabbar，用于判断是否开启动画

    var callbackOnFinishInit: ((Bool) -> Swift.Void)? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(rootVC: RootViewController) {
        self.rootVC = rootVC
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        // 根据不同的navTabbar类型设置baseView的尺寸
        // 之所以这么做，是因为baseView不会随着view尺寸而变化，而增加nav和tabbar时view会变化
        var baseViewFrame = view.frame
        if navTabType.contains(.TransparentNav) {
            baseViewFrame.origin.y = -64
        } else {
            baseViewFrame.size.height -= 64
        }
        if !navTabType.contains(.HideTab) {
            baseViewFrame.size.height -= 49
        }
        baseView = UIView(frame: baseViewFrame)
        view.addSubview(baseView)

        // 既然使用baseView并且自己指定尺寸，就不需要自动调整了，否则tableview会有问题
        automaticallyAdjustsScrollViewInsets = false

        // 初始化数据，根据设置的不同，在不同的时期进行
        if initDataOnViewAppear {
            baseView.alpha = 0
        } else {
            willInitData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rootVC.currentCtrlr = self
        handleNavTabState()
        BaseController.isLastTabbarHide = navTabType.contains(.HideTab)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if initDataOnViewAppear {
            willInitData()
            reshowView()
        }
    }

    // 初始化数据相关函数 -----------------------------------------------------------------------------
    private func willInitData() {
        if !hasInitData {
            initData()
            hasInitData = true
        }
    }

    func initData() {} //需要实现

    private func reshowView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.alpha = 1
        }, completion: callbackOnFinishInit)
    }

    // 设置导航栏和tabbar的样式 -----------------------------------------------------------------------------
    private func handleNavTabState() {
        let transparentNav = navTabType.contains(.TransparentNav)
        let hideTab = navTabType.contains(.HideTab)

        // 透明导航栏
        let bar = navigationController!.navigationBar
        let barAlpha: CGFloat = transparentNav ? 0.0 : 1.0
        if hideTab || BaseController.isLastTabbarHide { //如果不是前后都有tabbar，则用动效，否则瞬间移动过去
            UIView.animate(withDuration: 0.2, delay: transparentNav ? 0.2 : 0.0, options: .curveLinear, animations: {
                bar.subviews[0].alpha = barAlpha
            }, completion: nil)
        } else {
            bar.subviews[0].alpha = barAlpha
        }

        //隐藏tabbar
        let TabY: CGFloat = hideTab ? 60 : 0
        let delayTime: TimeInterval = hideTab ? 0.2 : 0.0
        let hideTabOpt: UIViewAnimationOptions = hideTab ? .curveEaseIn : .curveEaseOut
        UIView.animate(withDuration: 0.2, delay: delayTime, options: hideTabOpt, animations: {
            self.rootVC.myTabBar.transform = CGAffineTransform(translationX: 0, y: TabY)
        }, completion: nil)

        rootVC.myTabBar.isUserInteractionEnabled = !hideTab //隐藏时不可用
    }
}
