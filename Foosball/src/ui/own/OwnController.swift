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

class OwnController: BaseController, UITableViewDelegate, UITableViewDataSource {
    //信息头，比赛成绩，QR，其他项目等group
    let group = [
        //section
        [
            NorCellData(i: "share", t: "福利", st: ""),
        ],
        [
            NorCellData(i: "share", t: "分享", st: "分享"),
            NorCellData(i: "feedback", t: "反馈", st: ""),
        ],
        [
            NorCellData(i: "setting", t: "账号", st: ""),
            NorCellData(i: "setting", t: "隐私", st: ""),
            NorCellData(i: "setting", t: "消息提醒", st: ""),
            NorCellData(i: "setting", t: "其他设置", st: ""),
        ],
        [
            NorCellData(i: "setting", t: "关于", st: ""),
            NorCellData(i: "setting", t: "版本信息", st: ""),
        ],
        [
            NorCellData(i: "share", t: "退出", st: ""),
        ],
    ]

    var infoHead: InfoHeadView! = nil
    var tableView: UITableView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print("个人页面")

        //隐藏导航栏，并让tableview位置忽略导航栏
        navTabType = .HideNav
        automaticallyAdjustsScrollViewInsets = false

        //创建tableView
        tableView = UITableView(frame: view.bounds, style: .Grouped)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 96, right: 0) //48 ＋ 48 tabbar向上48个像素结束

        //设置tableview的基本属性，分割线等
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条

        //添加信息头
        infoHead = InfoHeadView(scrollView: tableView)
        view.insertSubview(infoHead, aboveSubview: tableView)
        infoHead!.initUIData(bgImaName: "selfbg", headImgName: "default_avatar", titleStr: "聂小倩", subTitleStr: "个性签名，啦啦啦")
    }

    //table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2 + group.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 1
        } else {
            return group[section - 2].count
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return OwnScoreCell.getCellHeight()
            } else {
                return OwnRankCell.getCellHeight()
            }
        } else if (indexPath.section == 1) {
            return OwnQRCell.getCellHeight()
        } else {
            return OwnNormalCell.getCellHeight()
        }
    }

    let ownScoCellId = "OScoCellId"
    let ownQRCellId = "OQRCId"
    let ownNorCellId = "ONorCId"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //比赛成绩
                cell = tableView.dequeueReusableCellWithIdentifier(ownScoCellId)
                if cell == nil {
                    cell = OwnScoreCell(reuseIdentifier: ownScoCellId)
                }
            } else {
                //排名
                cell = tableView.dequeueReusableCellWithIdentifier(ownScoCellId)
                if cell == nil {
                    cell = OwnRankCell(reuseIdentifier: ownScoCellId)
                }
            }
        } else if (indexPath.section == 1) {
            //二维码
            cell = tableView.dequeueReusableCellWithIdentifier(ownQRCellId)
            if cell == nil {
                cell = OwnQRCell(reuseIdentifier: ownQRCellId)
            }
        } else {
            //其他项目
            cell = tableView.dequeueReusableCellWithIdentifier(ownNorCellId)
            if cell == nil {
                cell = OwnNormalCell(reuseIdentifier: ownNorCellId)

                let data: NorCellData = group[indexPath.section - 2][indexPath.row]
                let norCell = cell as! OwnNormalCell
                norCell.setUIData(image: data.img, title: data.title, subTitle: data.subTitle)
            }
        }
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    //scroll view
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
//    }
}

















