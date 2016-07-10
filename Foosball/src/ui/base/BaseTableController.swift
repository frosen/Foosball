//
//  BaseTableController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class BaseTableController: UITableViewController {

    //设置导航栏控件，如果检测未登陆则使用登陆注册，如果未调用此接口则不设置
    func initNavBar() {
        //左

        //右
        navigationItem.rightBarButtonItem = createBarBtnItem("onClickSearch:", image: "search")
    }

    func createBarBtnItem(action: Selector, image img: String) -> UIBarButtonItem {
        let btn = UIButton(type: .Custom)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        btn.setBackgroundImage(UIImage(named: img), forState: .Normal)
        let bSize = btn.currentBackgroundImage!.size
        btn.bounds = CGRect(x: 0, y: 0, width: bSize.width, height: bSize.height)
        return UIBarButtonItem(customView: btn)
    }

    //跳转到搜索页面
    func onClickSearch(sender: AnyObject) {
        print("search")
    }
}
