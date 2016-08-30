//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: NavTabController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView! = nil
    weak var event: Event! = nil

    func setData(event: Event) {
        self.event = event
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("详情页面")

        title = "详情"

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        //创建tableView
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { //title + detail + cash
            return 3
        } else if section == 1 { //person(s) + head
            return 1 + max(event.senderStateList.count, event.receiverStateList.count)
        } else if section == 2 { //比分(s) + head
            return 1 + event.scoreList.count
        } else { //对话(s) + head
            return 1 + event.msgList.count
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
        return 44
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
