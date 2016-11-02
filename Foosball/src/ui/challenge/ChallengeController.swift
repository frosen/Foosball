//
//  ChallengeController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeController: BaseTabController, UITableViewDelegate, UITableViewDataSource {
    var dataPage: Int = 1

    var tableView: UITableView! = nil

    var activeEventCount: Int = 0
    var activeEvents: [Event] = []

    override func viewDidLoad() {
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("挑战页面")

        initNavBar()
        
        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.bounces = false
        tableView.separatorStyle = .none //不用他的分割线，自己画

        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3) //否则滚动条和屏幕边会有一段间隔
    }

    override func initData() {
        activeEvents = AppManager.shareInstance.user!.activeEvents
        activeEventCount = activeEvents.count
        tableView.reloadData()
    }

    //table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return activeEventCount //因为要利用section的head作为留白，所以每个section就是一行数据
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //section用于记录数据了，所以其中的row数量就是1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5 //数据行之间的留白
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChallengeCell.getCellHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let e: Event = activeEvents[(indexPath as NSIndexPath).section]
        return BaseCell.create(indexPath, tableView: tableView, d: e, ctrlr: self) { indexPath in
            return BaseCell.CInfo(id: "chalCellId", c: ChallengeCell.self)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.rootVC = rootVC

        let e: Event = activeEvents[(indexPath as NSIndexPath).section]
        vc.setData(e)
        navigationController!.pushViewController(vc, animated: true)
    }
}
