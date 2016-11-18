//
//  CreateController.swift
//  Foosball
//  创建事件的页面
//  Created by luleyan on 2016/11/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateController: BaseTabController, UIScrollViewDelegate {

    var pageView: UIScrollView! = nil
    var subviews: [UIViewController]! = nil

    override func viewDidLoad() {
        navTabType = .HideTab
        super.viewDidLoad()
        print("创建事件的页面")

        // 位置初始化 自定义的转景，系统不会重置view的位置，所以自己来
        view.frame.origin.y += 64

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(CreateController.onBack), image: "go_back")

        // 添加page
        pageView = UIScrollView(frame: baseView.bounds)
        baseView.addSubview(pageView)

        pageView.backgroundColor = UIColor.orange
        pageView.isPagingEnabled = true
        pageView.bounces = false
        pageView.showsHorizontalScrollIndicator = false

        pageView.delegate = self

        //加载页面
        let pageVSize = pageView.frame.size
        subviews = [
            CreateCtrlrStep1(rootCtrlr: self, pageSize: pageVSize),
            CreateCtrlrStep2(rootCtrlr: self, pageSize: pageVSize),
            CreateCtrlrStep3(rootCtrlr: self, pageSize: pageVSize),
        ]

        pageView.contentSize = CGSize(width: pageVSize.width * CGFloat(subviews.count), height: pageVSize.height)
        for i in 0 ..< subviews.count {
            subviews[i].view.frame.origin.x = pageVSize.width * CGFloat(i)
            pageView.addSubview(subviews[i].view)
        }

    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
}






