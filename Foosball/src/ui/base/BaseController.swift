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
        view.backgroundColor = UIColor.white
        baseView = UIView(frame: view.frame)
        view.addSubview(baseView)

        let navBar = navigationController?.navigationBar
        if navBar != nil {
            navBar!.barTintColor = BaseColor
            navBar!.layer.shadowColor = UIColor.lightGray.cgColor
            navBar!.layer.shadowOpacity = 0.45
            navBar!.layer.shadowRadius = 3
            navBar!.layer.shadowOffset = CGSize(width: 0, height: 5)
        }

        // 初始化数据，根据设置的不同，在不同的时期进行
        if initDataOnViewAppear {
            baseView.alpha = 0
        } else {
            willInitData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handleNavTabState()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        UIView.animate(withDuration: 0.2, animations: {
            self.baseView.alpha = 1
        }) 
    }

    // 设置导航栏和tabbar的样式 -----------------------------------------------------------------------------
    func handleNavTabState() {
        let hideNav = navTabType.contains(.HideNav)
        let transparentNav = navTabType.contains(.TransparentNav)
        let hideTab = navTabType.contains(.HideTab)

        // 隐藏导航栏
        let bar = navigationController!.navigationBar
        let NavY: CGFloat = hideNav ? -64 : 0
        let hideNavOpt: UIViewAnimationOptions = hideNav ? .curveEaseIn : .curveEaseOut
        if hideNav && hideTab || (!hideNav && !hideTab) { //如果同时隐藏／显示tabbar，则用动效，否则瞬间移动过去
            UIView.animate(withDuration: 0.2, delay: 0.2, options: hideNavOpt, animations: {
                bar.transform = CGAffineTransform(translationX: 0, y: NavY)
                }, completion: nil)
        } else {
            bar.transform = CGAffineTransform(translationX: 0, y: NavY)
        }

        navigationItem.hidesBackButton = hideNav //隐藏时，同时隐藏后退按钮
        navigationController!.navigationBar.isUserInteractionEnabled = !hideNav //隐藏时不可用

        //透明导航栏
        UIView.animate(withDuration: 0.3, delay: transparentNav ? 0.2 : 0.0, options: .curveLinear, animations: {
            bar.subviews[0].alpha = transparentNav ? 0.0 : 1.0
            }, completion: nil)

        //隐藏tabbar
        let TabY: CGFloat = hideTab ? 60 : 0
        let hideTabOpt: UIViewAnimationOptions = hideTab ? .curveEaseIn : .curveEaseOut
        UIView.animate(withDuration: 0.2, delay: 0.2, options: hideTabOpt, animations: {
            self.rootVC.myTabBar.transform = CGAffineTransform(translationX: 0, y: TabY)
            }, completion: nil)

        rootVC.myTabBar.isUserInteractionEnabled = !hideTab //隐藏时不可用
    }
}
