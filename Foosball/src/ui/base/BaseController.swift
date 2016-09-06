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

struct NavTabType: OptionSetType {
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }

    static let None = NavTabType(rawValue: 0)

    static let HideNav = NavTabType(rawValue: 1)
    static let TransparentNav = NavTabType(rawValue: 2)
    static let HideTab = NavTabType(rawValue: 4)
}

class BaseController: UIViewController {

    var rootVC: RootViewController! = nil //根控制器
    var navTabType: NavTabType = .None

    var initDataOnViewAppear: Bool = false
    var hasInitData: Bool = false
    var baseView: UIView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        baseView = UIView(frame: view.frame)
        view.addSubview(baseView)

        // 初始化数据，根据设置的不同，在不同的时期进行
        if initDataOnViewAppear {
            baseView.alpha = 0
        } else {
            willInitData()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        handleNavTabState()
        if initDataOnViewAppear {
            willInitData()
            reshowView()
        }
    }

    // 初始化数据相关函数 -----------------------------------------------------------------------------
    func willInitData() {
        if !hasInitData {
            initData()
            hasInitData = true
        }
    }

    func initData() {} //需要实现

    func reshowView() {
        UIView.animateWithDuration(0.2) {
            self.baseView.alpha = 1
        }
    }

    // 设置导航栏和tabbar的样式 -----------------------------------------------------------------------------
    func handleNavTabState() {
        let hideNav = navTabType.contains(.HideNav)
        let transparentNav = navTabType.contains(.TransparentNav)
        let hideTab = navTabType.contains(.HideTab)

        // 隐藏导航栏
        let bar = navigationController!.navigationBar
        let NavY: CGFloat = hideNav ? -64 : 0
        let hideNavOpt: UIViewAnimationOptions = hideNav ? .CurveEaseIn : .CurveEaseOut
        if hideNav && hideTab || (!hideNav && !hideTab) { //如果同时隐藏／显示tabbar，则用动效，否则瞬间移动过去
            UIView.animateWithDuration(0.2, delay: 0.1, options: hideNavOpt, animations: {
                bar.transform = CGAffineTransformMakeTranslation(0, NavY)
                }, completion: nil)
        } else {
            bar.transform = CGAffineTransformMakeTranslation(0, NavY)
        }

        navigationItem.hidesBackButton = hideNav //隐藏时，同时隐藏后退按钮
        navigationController!.navigationBar.userInteractionEnabled = !hideNav //隐藏时不可用

        //透明导航栏
        UIView.animateWithDuration(0.3, delay: transparentNav ? 0.2 : 0.0, options: .CurveLinear, animations: {
            bar.subviews[0].alpha = transparentNav ? 0.0 : 1.0
            }, completion: nil)

        //隐藏tabbar
        let TabY: CGFloat = hideTab ? 60 : 0
        let hideTabOpt: UIViewAnimationOptions = hideTab ? .CurveEaseIn : .CurveEaseOut
        UIView.animateWithDuration(0.2, delay: 0.1, options: hideTabOpt, animations: {
            self.rootVC.myTabBar.transform = CGAffineTransformMakeTranslation(0, TabY)
            }, completion: nil)

        rootVC.myTabBar.userInteractionEnabled = !hideTab //隐藏时不可用
    }
}
