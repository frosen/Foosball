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
            return 1 + max(event.senderStateList.count, event.receiverStateList.count) //person(s) + head with title
        case 2:
            return 1 + event.scoreList.count //比分(s) + head + title
        case 3:
            return 1 + event.msgList.count //对话(s) + head + title
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
                return DetailTitleCell.getCellHeight()
            case 1:
                return DetailContentCell.getCellHeight()
            case 2:
                return DetailCashCell.getCellHeight()
            default:
                return 0
            }
        case 1: //person(s) + head
            if indexPath.row == 0 {
                return DetailTeamHeadCell.getCellHeight()
            } else {
                return DetailTeamCell.getCellHeight()
            }
        case 2: //比分(s) + head
            if indexPath.row == 0 {
                return DetailScoreHeadCell.getCellHeight()
            } else {
                return DetailScoreCell.getCellHeight()
            }
        case 3: //对话(s) + head
            if indexPath.row == 0 {
                return DetailMsgHeadCell.getCellHeight()
            } else {
                return DetailMsgCell.getCellHeight()
            }
        default:
            return 0
        }
    }

    let titleCId = "TitCId"
    let contentCId = "ConCId"
    let cashCId = "CasCId"
    let TeamHeadCId = "THCId"
    let TeamCId = "TCId"
    let ScoreHeadCId = "SHCId"
    let ScoreCId = "SCId"
    let MsgHeadCId = "MHCId"
    let MsgCId = "MCId"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?

        switch indexPath.section {
        case 0: //title + detail + cash
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCellWithIdentifier(titleCId)
                if cell == nil {
                    cell = DetailTitleCell(reuseIdentifier: titleCId)
                }
            case 1:
                cell = tableView.dequeueReusableCellWithIdentifier(contentCId)
                if cell == nil {
                    cell = DetailContentCell(reuseIdentifier: contentCId)
                }
            case 2:
                cell = tableView.dequeueReusableCellWithIdentifier(cashCId)
                if cell == nil {
                    cell = DetailCashCell(reuseIdentifier: cashCId)
                }
            default:
                break
            }
        case 1: //person(s) + head
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(TeamHeadCId)
                if cell == nil {
                    cell = DetailTeamHeadCell(reuseIdentifier: TeamHeadCId)
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(TeamCId)
                if cell == nil {
                    cell = DetailTeamCell(reuseIdentifier: TeamCId)
                }
            }
        case 2: //比分(s) + head
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(ScoreHeadCId)
                if cell == nil {
                    cell = DetailScoreHeadCell(reuseIdentifier: ScoreHeadCId)
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(ScoreCId)
                if cell == nil {
                    cell = DetailScoreCell(reuseIdentifier: ScoreCId)
                }
            }
        case 3: //对话(s) + head
            if indexPath.row == 0 {
                cell = tableView.dequeueReusableCellWithIdentifier(MsgHeadCId)
                if cell == nil {
                    cell = DetailMsgHeadCell(reuseIdentifier: MsgHeadCId)
                }
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(MsgCId)
                if cell == nil {
                    cell = DetailMsgCell(reuseIdentifier: MsgCId)
                }
            }
        default:
            break
        }

        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

    // 回调
    func onBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
