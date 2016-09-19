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

    func setData(_ event: Event) {
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
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none //不用他的分割线，自己画
    }

    override func initData() {
        sectionNum = 4
        tableView.reloadData()
    }

    //table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3 //title + detail + cash
        case 1:
            return 2 + max(event.ourSideStateList.count, event.opponentStateList.count) //person(s) + head with title 一定会有数据
        case 2:
            return 1 + (event.scoreList.count != 0 ? 1 : 0) + event.scoreList.count//比分(s) + head + title 如果没有数据则无title
        case 3:
            return 1 + (event.msgList.count != 0 ? 1 : 0) + event.msgList.count //对话(s) + head + title 如果没有数据则无title
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0: //title + detail + cash
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailTitleCell.getCellHeight()
            case 1:
                return DetailContentCell.getCellHeight()
            case 2:
                return DetailCashCell.getCellHeight()
            default:
                return 0
            }
        case 1: //person(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailTeamHeadCell.getCellHeight()
            case 1:
                return DetailTeamTitleCell.getCellHeight()
            default:
                return DetailTeamCell.getCellHeight()
            }
        case 2: //比分(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailScoreHeadCell.getCellHeight()
            case 1:
                return DetailScoreTitleCell.getCellHeight() //反正 event.scoreList.count == 0 也不会读取这里了
            default:
                return DetailScoreCell.getCellHeight()
            }
        case 3: //对话(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailMsgHeadCell.getCellHeight()
            case 1:
                return DetailMsgTitleCell.getCellHeight()
            default:
                return DetailMsgCell.getCellHeight()
            }
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return BaseCell.create(indexPath, tableView: tableView, e: event) { indexPath in
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "TitCId", c: DetailTitleCell.self)
                case 1:
                    return BaseCell.CInfo(id: "ConCId", c: DetailContentCell.self)
                default:
                    return BaseCell.CInfo(id: "CasCId", c: DetailCashCell.self)
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "THCId", c: DetailTeamHeadCell.self)
                case 1:
                    return BaseCell.CInfo(id: "TTCId", c: DetailTeamTitleCell.self)
                default:
                    return BaseCell.CInfo(id: "TCId", c: DetailTeamCell.self)
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "SHCId", c: DetailScoreHeadCell.self)
                case 1:
                    return BaseCell.CInfo(id: "STCId", c: DetailScoreTitleCell.self)
                default:
                    return BaseCell.CInfo(id: "SCId", c: DetailScoreCell.self)
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "MHCId", c: DetailMsgHeadCell.self)
                case 1:
                    return BaseCell.CInfo(id: "MTCId", c: DetailMsgHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "MCId", c: DetailMsgCell.self)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    // 回调
    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
    
}
