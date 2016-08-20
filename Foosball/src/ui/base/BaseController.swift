//
//  BaseTableController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class UITools: NSObject {
    class func createBarBtnItem(target: AnyObject, action: Selector, image img: String) -> UIBarButtonItem {
        let btn = UIButton(type: .Custom)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        btn.setBackgroundImage(UIImage(named: img), forState: .Normal)
        let bSize = btn.currentBackgroundImage!.size
        btn.bounds = CGRect(x: 0, y: 0, width: bSize.width, height: bSize.height)
        return UIBarButtonItem(customView: btn)
    }
}

class BaseController: NavTabController {

    //设置导航栏控件，如果检测未登陆则使用登陆注册，如果未调用此接口则不设置
    func initNavBar() {
        //左
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseController.onClickScan(_:)), image: "scan")

        //右
        navigationItem.rightBarButtonItem = UITools.createBarBtnItem(self, action: #selector(BaseController.onClickSearch(_:)), image: "search")
    }

    //跳转到二维码扫描页面
    func onClickScan(sender: AnyObject) {
        print("scan")
        let vc = ScanViewController()
        vc.rootVC = rootVC
        navigationController!.pushViewController(vc, animated: true)
    }

    //跳转到搜索页面
    func onClickSearch(sender: AnyObject) {
        print("search")
    }
}
