//
//  CreateController.swift
//  Foosball
//  创建事件的页面
//  Created by luleyan on 2016/11/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateController: BaseController, UIScrollViewDelegate {

    var pageView: UIScrollView! = nil
    var subviews: [CreatePageBaseCtrlr]! = nil

    var page: Int = 0

    override func viewDidLoad() {
        navTabType = [.HideTab, .TransparentNav]
        super.viewDidLoad()
        print("创建事件的页面")

        // 位置初始化 自定义的转景，系统不会重置view的位置，所以自己来
        view.frame.origin.y += 64

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(CreateController.onBack), image: "go_back")

        // 添加page
        pageView = UIScrollView(frame: baseView.bounds)
        baseView.addSubview(pageView)

        pageView.isPagingEnabled = true
        pageView.bounces = false
        pageView.showsHorizontalScrollIndicator = false

        pageView.delegate = self

        pageView.isScrollEnabled = false //禁止手动滑动

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

    // 移动到另一页，参数true向右
    func movePage(gotoRight: Bool) {
        page += ( gotoRight ? 1 : -1)
        let nextX = CGFloat(page) * pageView.frame.size.width
        pageView.setContentOffset(CGPoint(x: nextX, y: 0), animated: true)
    }
}






