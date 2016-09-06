//
//  BaseTableController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class UITools {
    class func createBarBtnItem(target: AnyObject, action: Selector, image img: String) -> UIBarButtonItem {
        let btn = UIButton(type: .Custom)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.setBackgroundImage(UIImage(named: img), forState: .Normal)
        let bSize = btn.currentBackgroundImage!.size
        btn.bounds = CGRect(x: 0, y: 0, width: bSize.width, height: bSize.height)
        return UIBarButtonItem(customView: btn)
    }

    class func showAlert(target: UIViewController, title: String, msg: String, type: Int, callback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: callback))
        if type == 2 {
            alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        }
        target.presentViewController(alert, animated: true, completion: nil)
    }
}

class BaseController: NavTabController {
    var initDataOnViewAppear: Bool = false
    var hasInitData: Bool = false

    // 初始化数据，根据设置的不同，在不同的时期进行---------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        if initDataOnViewAppear {
            view.alpha = 0
        } else {
            willInitData()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if initDataOnViewAppear {
            willInitData()
            reshowView()
        }
    }

    func willInitData() {
        if !hasInitData {
            initData()
            hasInitData = true
        }
    }

    func initData() {} //需要实现

    func reshowView() {
        UIView.animateWithDuration(0.2) {
            self.view.alpha = 1
        }
    }
}

extension BaseController {
    //设置导航栏控件，如果检测未登陆则使用登陆注册，如果未调用此接口则不设置-----------------------------------------------------
    func initNavBar() {
        //左
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseController.onClickScan), image: "scan")

        //右
        navigationItem.rightBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseController.onClickSearch), image: "search")
    }

    //跳转到二维码扫描页面
    func onClickScan() {
        print("scan")
        let vc = ScanViewController()
        vc.rootVC = rootVC
        navigationController!.pushViewController(vc, animated: true)
    }

    //跳转到搜索页面
    func onClickSearch() {
        print("search")
    }
}
