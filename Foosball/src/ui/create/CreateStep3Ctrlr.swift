//
//  CreateStep3Ctrlr.swift
//  Foosball
//  时间地点，兑现物，其他详情
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3Ctrlr: CreatePageBaseCtrlr, UITableViewDelegate, UITableViewDataSource, StaticCellDelegate, CreateStep3ToolbarDelegate {

    private var tableView: UITableView! = nil
    private var toolbar: CreateStep3Toolbar! = nil
    
    override func setUI() {
        // tableView的样子和detail类似
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: pageSize.width, height: pageSize.height - 64))
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条
        tableView.backgroundColor = UIColor.white

        //底部的按钮层 直接发布、邀请朋友
        toolbar = CreateStep3Toolbar()
        view.addSubview(toolbar)
        toolbar.delegate = self
        toolbar.frame.origin.y = view.frame.height - toolbar.frame.height

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolbar.frame.height, right: 0)
    }

    // tableview -----------------------------------------------------------------------

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3 // head + 时间 + 地点
        case 1:
            return 2 // 标题 + 默认的一个
        default:
            return 1 // 标题
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : 25
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return CreateStep3TimeHeadCell.getCellHeight()
            case 1:
                return CreateStep3TimeCell.getCellHeight(rootCtrlr.createEvent)
            default:
                return CreateStep3LocationCell.getCellHeight(rootCtrlr.createEvent)
            }
        case 1:
            switch indexPath.row {
            case 0:
                return CreateStep3WagerHeadCell.getCellHeight()
            default:
                return CreateStep3WagerCell.getCellHeight()
            }
        default:
            switch indexPath.row {
            case 0:
                return CreateStep3DetailHeadCell.getCellHeight()
            default:
                return CreateStep3DetailCell.getCellHeight()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: rootCtrlr.createEvent, ctrlr: self, delegate: self)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white // 如果不加上这一句，则table cell的header会为灰色
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.white // 如果不加上这一句，则table cell的footer会为灰色
    }

    // BaseCellDelegate --------------------------------------------------------------

    func getCInfo(_ indexPath: IndexPath) -> BaseCell.CInfo {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return BaseCell.CInfo(id: "CS3TimeHCId", c: CreateStep3TimeHeadCell.self)
            case 1:
                return BaseCell.CInfo(id: "CS3TimeCId", c: CreateStep3TimeCell.self)
            default:
                return BaseCell.CInfo(id: "CS3LocCId", c: CreateStep3LocationCell.self)
            }
        case 1:
            switch indexPath.row {
            case 0:
                return BaseCell.CInfo(id: "CS3WagerHCId", c: CreateStep3WagerHeadCell.self)
            default:
                return BaseCell.CInfo(id: "CS3WagerCId", c: CreateStep3WagerCell.self)
            }
        default:
            switch indexPath.row {
            case 0:
                return BaseCell.CInfo(id: "CS3DetailHCId", c: CreateStep3DetailHeadCell.self)
            default:
                return BaseCell.CInfo(id: "CS3DetailCId", c: CreateStep3DetailCell.self)
            }
        }
    }

    func getIfUpdate(_ indexPath: IndexPath) -> Bool {
        return false
    }
}
