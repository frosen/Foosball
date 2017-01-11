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

    private var pageView: UIScrollView! = nil
    private var subviews: [CreatePageBaseCtrlr]! = nil

    private var page: Int = 0

    override func viewDidLoad() {
        navTabType = [.HideTab, .TransparentNav]
        super.viewDidLoad()
        print("创建事件的页面")

        // 导航栏
        UITools.createNavBackBtn(self, action: #selector(CreateController.onBack))
        setStepLebel()

        initCreateEvent() // 初始化数据
        initUIData()
    }

    // 设置步骤
    private var stepLabel: UIBarButtonItem! = nil // 用于记录步骤
    private func setStepLebel() {
        if stepLabel == nil {
            stepLabel = UIBarButtonItem(title: "1/3", style: .done, target: nil, action: nil)
            stepLabel.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
            stepLabel.isEnabled = false
            navigationItem.rightBarButtonItem = stepLabel
        }
        let stepStr: String = String(page + 1) + "/" + String(subviews.count)
        stepLabel.title! = stepStr
    }

    func initCreateEvent() {
        createEvent = Event(ID: DataID(ID: "-1"))
        createEvent.time = Time(timeIntervalSinceNow: 1800) // 往后30分钟

        createEvent.location.fetchCurLoc{_,_,_ in }

        changeCreateEventWager(isAdd: true)
    }

    func initUIData() {
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
            CreateStep1Ctrlr(rootCtrlr: self, pageSize: pageVSize),
            CreateStep2Ctrlr(rootCtrlr: self, pageSize: pageVSize),
            CreateStep3Ctrlr(rootCtrlr: self, pageSize: pageVSize),
            CreateStep4Ctrlr(rootCtrlr: self, pageSize: pageVSize),
        ]

        pageView.contentSize = CGSize(width: pageVSize.width * CGFloat(subviews.count), height: pageVSize.height)
        for i in 0 ..< subviews.count {
            subviews[i].view.frame.origin.x = pageVSize.width * CGFloat(i)
            pageView.addSubview(subviews[i].view)
        }
    }

    private func goBackToHome() {
        let _ = navigationController?.popViewController(animated: true)
    }

    func onBack() {
        if page == 0 {
            goBackToHome()
        } else {
            movePage(gotoRight: false)
        }
    }

    // 完成创建
    func finish() {
        // 整理并上传event数据
        let userState = UserState(user: APP.userMgr.data.getBrief(), state: .ready)
        createEvent.ourSideStateList.append(userState)
        createEvent.createTime = Time.now
        createEvent.createUserID = APP.userMgr.data.ID

        APP.activeEventsMgr.addNewEvent(createEvent) { suc, error in
            if suc {
                // 返回
                self.goBackToHome()
            }
        }
    }

    // 移动到另一页，参数true向右
    func movePage(gotoRight: Bool) {
        subviews[page].gotoDisappear()
        page += ( gotoRight ? 1 : -1)
        setStepLebel()
        let nextX = CGFloat(page) * pageView.frame.size.width
        pageView.setContentOffset(CGPoint(x: nextX, y: 0), animated: true)
        subviews[page].gotoAppear()
    }

    // 增减wager
    func changeCreateEventWager(isAdd: Bool) {
        if isAdd == true {
            createEvent.wager.append((1, 0, 0))
        } else {
            createEvent.wager.remove(at: createEvent.wager.count - 1)
        }
    }
}






