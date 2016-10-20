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

    var isShowKeyboard: Bool = false
    var keyboardH: CGFloat = 0 //暂存用
    var textInputView: InputView! = nil

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

        tableView.separatorInset = UIEdgeInsets(top: 0, left: DetailG.headMargin, bottom: 0, right: DetailG.headMargin)
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条
//        tableView.backgroundColor = UIColor.white //最后再让背景变成白色，否则现在不易设计

        //按钮栏

        //隐藏在最下面的输入栏
        textInputView = InputView()
        baseView.addSubview(textInputView)

        // 初始化时，y为总高是为了隐藏到最底下
        var inputFrame = textInputView.frame
        inputFrame.origin.y = UIScreen.main.bounds.height
        textInputView.frame = inputFrame

        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyBoardWillHide), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.endInput(ges:)))
        baseView.addGestureRecognizer(tap)
        
    }

    override func initData() {
        sectionNum = 4
        tableView.reloadData()
    }

    // table view delegate ==================================================================================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3 //title + detail + cash
        case 1:
            //head 友 敌 2. 如果是乱斗应该是不分敌友的所以是2行，但暂时不考虑；3. 以后也可能加入观众，暂不考虑
            return 3 //友一定有自己，敌如果没有也有个标题表示没有的状态
        case 2:
            return 1 + (event.imageURLList.count > 0 ? 1 : 0) //head body
        case 3:
            return 1 + event.msgList.count //对话(s) + head
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
                return DetailContentCell.getCellHeight(event, index: indexPath)
            case 2:
                return DetailCashCell.getCellHeight(event, index: indexPath)
            default:
                return 0
            }
        case 1: //person(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailTeamHeadCell.getCellHeight()
            default:
                return DetailTeamCell.getCellHeight(event, index: indexPath)
            }
        case 2: //比分(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailImageHeadCell.getCellHeight()
            default:
                return DetailImageCell.getCellHeight(event, index: indexPath)
            }
        case 3: //对话(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailMsgHeadCell.getCellHeight()
            default:
                return DetailMsgCell.getCellHeight(event, index: indexPath)
            }
        default:
            return 0
        }
    }

    let imageCellId = "ICId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: event, ctrlr: self) { indexPath in
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
                default:
                    return BaseCell.CInfo(id: "TCId", c: DetailTeamCell.self)
                }
            case 2:
                switch (indexPath as NSIndexPath).row {
                case 0:
                    return BaseCell.CInfo(id: "IHCId", c: DetailImageHeadCell.self)
                default:
                    return BaseCell.CInfo(id: imageCellId, c: DetailImageCell.self)
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

    }

    // 回调 ==================================================================================================================
    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }

    // 修改event 被cell调用 changeType: C改变当前，N在当前添加，D删除当前，A所有的重刷
    func changeEvent(_ indexPath: IndexPath, changeType: String, changeFunc: (_ e: Event) -> Void ) {
        // 修改event
        changeFunc(event)

        //
    }

    // 虚拟键盘和输入相关
    func keyboardWillShow(note: Notification) {
        let userInfo = (note as NSNotification).userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        keyboardH = keyBoardBounds.size.height

        isShowKeyboard = true

        let animations:(() -> Void) = {
            self.baseView.transform = CGAffineTransform(translationX: 0, y: -self.keyboardH - self.textInputView.frame.height)
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    func keyBoardWillHide(note: Notification) {
        let userInfo = (note as NSNotification).userInfo!
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        isShowKeyboard = false

        let animations:(() -> Void) = {
            self.baseView.transform = CGAffineTransform.identity
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }

    func beginInput() {
        print("saying")
        textInputView.beginInput()
    }

    func endInput(ges: UITapGestureRecognizer) {
        if isShowKeyboard == true {
            textInputView.endInput()
        }
    }

    func onInputViewHeightReset() {
        if isShowKeyboard == true {
            baseView.transform = CGAffineTransform(translationX: 0, y: -keyboardH - self.textInputView.frame.height)
        } else {
            baseView.transform = CGAffineTransform.identity
        }
    }
}
