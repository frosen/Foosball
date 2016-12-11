//
//  CreateController.swift
//  Foosball
//  创建事件的页面
//  Created by luleyan on 2016/11/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateController: BaseController, UIScrollViewDelegate {

    var createEvent: Event! = nil

    var pageView: UIScrollView! = nil
    var subviews: [CreatePageBaseCtrlr]! = nil

    var page: Int = 0

    override func viewDidLoad() {
        navTabType = [.HideTab, .TransparentNav]
        super.viewDidLoad()
        print("创建事件的页面")

        // 位置初始化 自定义的转景，系统不会重置view的位置，所以自己来
        view.frame.origin.y += 64
        baseView.backgroundColor = UIColor(red: 0.12, green: 0.12, blue: 0.24, alpha: 1)

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
            CreateCtrlrStep4(rootCtrlr: self, pageSize: pageVSize),
        ]

        pageView.contentSize = CGSize(width: pageVSize.width * CGFloat(subviews.count), height: pageVSize.height)
        for i in 0 ..< subviews.count {
            subviews[i].view.frame.origin.x = pageVSize.width * CGFloat(i)
            pageView.addSubview(subviews[i].view)
        }

        // 导航栏
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(CreateController.onBack), image: "go_back")
        setStepLebel()
    }

    func onBack() {
        if page == 0 {
            let _ = navigationController?.popViewController(animated: true)
        } else {
            movePage(gotoRight: false)
        }
    }

    // 移动到另一页，参数true向右
    func movePage(gotoRight: Bool) {
        page += ( gotoRight ? 1 : -1)
        setStepLebel()
        let nextX = CGFloat(page) * pageView.frame.size.width
        pageView.setContentOffset(CGPoint(x: nextX, y: 0), animated: true)
    }

    // 设置步骤
    var stepLabel: UIBarButtonItem! = nil // 用于记录步骤
    func setStepLebel() {
        if stepLabel == nil {
            stepLabel = UIBarButtonItem(title: "1/3", style: .done, target: nil, action: nil)
            stepLabel.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
            stepLabel.isEnabled = false
            navigationItem.rightBarButtonItem = stepLabel
        }
        let stepStr: String = String(page + 1) + "/" + String(subviews.count)
        stepLabel.title! = stepStr
    }
}






