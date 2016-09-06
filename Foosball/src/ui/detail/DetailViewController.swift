//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView! = nil
    weak var event: Event! = nil
    var sectionNum: Int = 0

    func setData(event: Event) {
        self.event = event
    }
    
    override func viewDidLoad() {
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("详情页面")

        title = "详情"
        navTabType = [.HideTab]

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .Grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        print("h")
    }

    override func initData() {
        sectionNum = 4
        tableView.reloadData()
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3 //title + detail + cash
        case 1:
            return 1 + max(event.senderStateList.count, event.receiverStateList.count) //person(s) + head
        case 2:
            return 1 + event.scoreList.count //比分(s) + head
        case 3:
            return 1 + event.msgList.count //对话(s) + head
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 10
        }
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: //title + detail + cash
            switch indexPath.row {
            case 0:
                return 44
            case 1:
                return 66
            case 2:
                return 66
            default:
                return 0
            }
        case 1:
            return 44 //person(s) + head
        case 2:
            return 44 //比分(s) + head
        case 3:
            return 44 //对话(s) + head
        default:
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    // 回调
    func onBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
