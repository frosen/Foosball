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

        tableView.separatorStyle = .None //不用他的分割线，自己画

        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3) //否则滚动条和屏幕边会有一段间隔
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1

    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
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
//        cell.setData()

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = DetailViewController()
        vc.rootVC = rootVC

        let e = Event(id: DataID(ID: 1111), item: Foosball)
        vc.setData(e)
        navigationController!.pushViewController(vc, animated: true)
    }


}
