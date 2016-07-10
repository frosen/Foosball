//
//  OwnController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

struct NorCellData {
    let img: String
    let title: String
    let subTitle: String
    init(i: String, t: String, st: String) {
        img = i
        title = t
        subTitle = st
    }
}

class OwnController: BaseTableController {
    //
    let group = [
        //section
        [
            NorCellData(i: "share", t: "分享", st: "分享"),
            NorCellData(i: "feedback", t: "反馈", st: ""),
        ],
        [
            NorCellData(i: "setting", t: "设置", st: ""),
        ],
    ]

    init() {
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("个人页面")

        //隐藏导航栏，并让tableview位置忽略导航栏
        navigationController!.navigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)

        //设置tableview的基本属性，分割线等
        tableView.separatorInset = UIEdgeInsetsZero
    }

    //table view
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + group.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0 || section == 1) {
            return 1
        } else {
            return group[section - 2].count
        }

    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 0.1
        } else {
            return 10
        }
    }

    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return OwnTitleCell.getCellHeight()
        } else if (indexPath.section == 1) {
            return OwnQRCell.getCellHeight()
        } else {
            return OwnNormalCell.getCellHeight()
        }
    }

    let ownTitleCellId = "OTCId"
    let ownNorCellId = "ONCId"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier(ownTitleCellId)
            if (cell == nil) {
                cell = OwnTitleCell(style: .Default, reuseIdentifier: ownTitleCellId)
            }
            return cell!
        } else if (indexPath.section == 1) {
            var cell = tableView.dequeueReusableCellWithIdentifier(ownTitleCellId)
            if (cell == nil) {
                cell = OwnQRCell(style: .Default, reuseIdentifier: ownTitleCellId)
            }
            return cell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier(ownNorCellId)
            if (cell == nil) {
                cell = OwnNormalCell(style: .Value1, reuseIdentifier: ownNorCellId)

                let data: NorCellData = group[indexPath.section - 2][indexPath.row]
                cell!.imageView!.image = UIImage(named: data.img)
                cell!.textLabel!.text = data.title
                cell!.detailTextLabel!.text = data.subTitle
                cell!.accessoryType = .DisclosureIndicator
            }
            return cell!
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    //scroll view
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//    }
}

















