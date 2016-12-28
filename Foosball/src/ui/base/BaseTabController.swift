//
//  BaseTabController.swift
//  TheOneFoosball2
//  主页的controller
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class BaseTabController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
    }

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
        let vc = ScanViewController(rootVC: rootVC)
        navigationController!.pushViewController(vc, animated: true)
    }

    //跳转到搜索页面
    func onClickSearch() {
        print("search")
        let vc = SearchController(rootVC: rootVC)
        navigationController!.pushViewController(vc, animated: true)
    }
}
