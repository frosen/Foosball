//
//  BaseTabController.swift
//  TheOneFoosball2
//  主页的controller
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

class BaseTabController: BaseController {
    //设置导航栏控件，如果检测未登陆则使用登陆注册，如果未调用此接口则不设置-----------------------------------------------------
    func initNavBar() {
        //左
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseTabController.onClickScan), image: "scan")

        //右
        navigationItem.rightBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseTabController.onClickSearch), image: "search")
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
