//
//  CreateStep3Ctrlr.swift
//  Foosball
//  时间地点，兑现物，其他详情
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
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2 // 时间 + 地点
        case 1:
            return 2 // 标题 + 默认的一个
        default:
            return 1 // 标题
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: rootCtrlr.createEvent, ctrlr: self) { indexPath in
            switch (indexPath as NSIndexPath).section {
            case 0:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                default:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                }
            case 1:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                default:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                }
            default:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                default:
                    return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! BaseCell
        cell.onSelected()
    }
}
