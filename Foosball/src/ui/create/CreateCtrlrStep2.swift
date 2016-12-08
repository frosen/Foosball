//
//  CreateCtrlrStep2.swift
//  Foosball
//
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateCtrlrStep2: CreatePageBaseCtrlr, UITableViewDelegate, UITableViewDataSource {

    var tableview: UITableView! = nil

    override func setUI() {
        tableview = UITableView(frame: CGRect(x: 0, y: 64, width: pageSize.width, height: pageSize.height - 64))
        view.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
    }

    // tableview -----------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ItemType.count
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

    let step2CellId = "step2CellId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: step2CellId)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: step2CellId)
        }
        print(ItemType.list[indexPath.row].name)
        cell!.textLabel!.text = ItemType.list[indexPath.row].name

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rootCtrlr.movePage(gotoRight: true)
    }
}
