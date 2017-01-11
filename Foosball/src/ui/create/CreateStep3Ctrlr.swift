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

    private(set) var isEnableInputDetail: Bool = false
    
    override func setUI() {
        // tableView的样子和detail类似
        // 用grouped，header和footer没有颜色，设置了背景后header和footer和背景色一直，
        // 不用grouped, header和footer会变暗，要在willDisplayHeaderView中设置其tint color才行
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: pageSize.width, height: pageSize.height - 64), style: .grouped)
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

        //输入相关
        let tap = UITapGestureRecognizer(target: self, action: #selector(CreateStep3Ctrlr.endInput))
        view.addGestureRecognizer(tap)
    }

    override func gotoAppear() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateStep3Ctrlr.keyboardWillShow), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateStep3Ctrlr.keyBoardWillHide), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
    }

    override func gotoDisappear() {
        endInput()
        NotificationCenter.default.removeObserver(self)
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
            return 1 + rootCtrlr.createEvent.wager.count // 标题 + 默认的一个
        default:
            return 1 + (isEnableInputDetail ? 1 : 0) // 标题 + 内容
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
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

    // CreateStep3ToolbarDelegate ================================================================================================

    func onPublish() {
        UITools.showAlert(rootCtrlr, title: "确认发布", msg: "是否确认直接发布?", type: 2) { act in
            self.rootCtrlr.createEvent.isPublishToMap = true
            self.rootCtrlr.finish()
        }
    }

    func onGoon() {
        
    }

    // 输入文字相关方法 =================================================================================================

    func keyboardWillShow(note: Notification) {
        print("keyboardWillShow")
        let userInfo = (note as NSNotification).userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        toolbar.isHidden = true

        let animations: (() -> Void) = {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardBounds.size.height, right: 0)
            self.tableView.contentOffset.y += (keyBoardBounds.size.height - self.toolbar.frame.height)
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations)
        }else{
            animations()
        }
    }

    func keyBoardWillHide(note: Notification) {
        print("keyBoardWillHide")
        let userInfo = (note as NSNotification).userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        toolbar.isHidden = false

        let animations:(() -> Void) = {
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: self.toolbar.frame.height, right: 0)
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations)
        }else{
            animations()
        }
    }

    func endInput() {
        let c = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
        if c == nil {
            return
        }

        let inputCell = c! as! CreateStep3DetailCell
        inputCell.endInput()
    }

    // 开放的方法 ==========================================================================================================================

    // 调整奖杯数量，然后重新刷新cell
    func modifyWagerCount(add: Bool) {
        tableView.beginUpdates()

        if add == true {
            rootCtrlr.changeCreateEventWager(isAdd: true)
            tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
        } else {
            rootCtrlr.changeCreateEventWager(isAdd: false)
            tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
        }

        tableView.endUpdates()
    }

    func setDetailInputEnable(_ isOn: Bool) {
        tableView.beginUpdates()

        isEnableInputDetail = isOn
        if isOn == true {
            tableView.insertRows(at: [IndexPath(row: 1, section: 2)], with: .fade)
        } else {
            tableView.deleteRows(at: [IndexPath(row: 1, section: 2)], with: .fade)
        }

        tableView.endUpdates()

        if isOn == true { // 往下移动一些，并进入输入状态
            tableView.scrollToRow(at: IndexPath(row: 1, section: 2), at: .bottom, animated: true)

            let c = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
            let inputCell = c! as! CreateStep3DetailCell
            inputCell.beginInput()
        }
    }
}
