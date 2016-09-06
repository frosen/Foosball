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

    var activeEvents: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("挑战页面")

        initNavBar()
        
        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .Grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.bounces = false
        tableView.separatorStyle = .None //不用他的分割线，自己画

        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3) //否则滚动条和屏幕边会有一段间隔

        //引用数据-------------
        activeEvents = AppManager.shareInstance.user!.activeEvents
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return activeEvents.count //因为要利用section的head作为留白，所以每个section就是一行数据
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //section用于记录数据了，所以其中的row数量就是1
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5 //数据行之间的留白
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return ChallengeCell.getCellHeight()
    }

    let chalCellId = "chalCellId"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        cell = tableView.dequeueReusableCellWithIdentifier(chalCellId)
        if cell == nil {
            cell = ChallengeCell(reuseIdentifier: chalCellId)
        }

        let e: Event = activeEvents[indexPath.section]
        let cCell = cell as! ChallengeCell
        cCell.setData(e)

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DetailViewController()
        vc.rootVC = rootVC

        let e: Event = activeEvents[indexPath.section]
        vc.setData(e)
        navigationController!.pushViewController(vc, animated: true)
    }

    //更新cell 不使用reload，而是用动画，
    //在此之前必须更新好数据源，否则发现numberOfSectionsInTableView什么的不对了会报错
    func resetCell() {

        tableView.beginUpdates()

        //更新cell数据
        tableView.reloadSections(NSIndexSet(index: 3), withRowAnimation: .None)

        //插入删除
        let set = NSIndexSet(index: 0)
        tableView.insertSections(set, withRowAnimation: .Fade)

        let set2 = NSIndexSet(index: 2)
        tableView.deleteSections(set2, withRowAnimation: .Fade)

        tableView.endUpdates()
    }
}
