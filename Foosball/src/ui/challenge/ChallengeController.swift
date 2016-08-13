//
//  ChallengeController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeController: BaseController, UITableViewDelegate, UITableViewDataSource {
    var dataPage: Int = 1

    var tableView: UITableView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("挑战页面")

        initNavBar()

        //创建tableView
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .None
    }

    override func viewWillAppear(animated: Bool) {
        
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
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
        cell.setData()

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}
