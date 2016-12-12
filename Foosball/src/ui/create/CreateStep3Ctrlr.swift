//
//  CreateStep3Ctrlr.swift
//  Foosball
//  时间，地点，兑现物，其他详情
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3Ctrlr: CreatePageBaseCtrlr, UITableViewDelegate, UITableViewDataSource {

    var tableview: UITableView! = nil
    
    override func setUI() {
        tableview = UITableView(frame: CGRect(x: 0, y: 64, width: pageSize.width, height: pageSize.height - 64 - 49)) // 要减去底部按钮层的高度
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self

        //底部的按钮层 直接发布、邀请朋友
    }

    // tableview -----------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: rootCtrlr.createEvent, ctrlr: self) { indexPath in
            switch (indexPath as NSIndexPath).section {
            case 0:
                return BaseCell.CInfo(id: "CS3TimeCId", c: DetailTitleCell.self)
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "THCId", c: DetailTeamHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "TCId", c: DetailTeamCell.self)
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "IHCId", c: DetailImageHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "ICId", c: DetailImageCell.self)
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "MHCId", c: DetailMsgHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "MCId", c: DetailMsgCell.self)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootCtrlr.movePage(gotoRight: true)
    }
}
