//
//  CreateCtrlrStep3.swift
//  Foosball
//  时间，地点，兑现物，其他详情
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateCtrlrStep3: CreatePageBaseCtrlr, UITableViewDelegate, UITableViewDataSource {

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

    let step2CellId = "step3CellId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: step2CellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: step2CellId)
        }
        print(ItemType.list[indexPath.row].name)
        cell!.imageView!.image = UIImage(named: "setting")
        cell!.textLabel!.text = ItemType.list[indexPath.row].name

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootCtrlr.movePage(gotoRight: true)
    }
}
