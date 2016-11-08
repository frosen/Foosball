//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, ActiveEventsMgrObserver, UITableViewDelegate, UITableViewDataSource, DetailToolbarDelegate, InputViewDelegate {

    var curEventId: DataID! = nil
    var curEvent: Event! = nil
    var sectionNum: Int = 0

    var tableView: UITableView! = nil
    var toolbar: DetailToolbar! = nil
    var textInputView: InputView! = nil
    var isShowKeyboard: Bool = false

    func setDataId(_ id: DataID) {
        self.curEventId = id
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
        toolbar = DetailToolbar()
        baseView.addSubview(toolbar)
        toolbar.delegate = self
        toolbar.frame.origin.y = UIScreen.main.bounds.height - toolbar.h

        //隐藏在最下面的输入栏
        textInputView = InputView()
        baseView.addSubview(textInputView)
        textInputView.delegate = self

        // 初始化时，y为总高是为了隐藏到最底下，并且隐藏
        textInputView.frame.origin.y = UIScreen.main.bounds.height
        textInputView.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyBoardWillHide), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.endInput(ges:)))
        baseView.addGestureRecognizer(tap)
        
    }

    override func initData() {
        APP.activeEventsMgr.register(observer: self, key: "DetailViewController")

    }

    // ActiveEventsMgrObserver
    func onInit(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            sectionNum = 4
            curEvent = e
            tableView.reloadData()
        }
    }

    func onModify(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            print(e.memberCount)
        }
    }

    func getCurEvent(_ activeEvents: [Event]) -> Event? {
        for e in activeEvents {
            if e.ID == curEventId {
                return e
            }
        }
        return nil
    }

    // table view delegate ==========================================================================================

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
            return 1 + (curEvent.imageURLList.count > 0 ? 1 : 0) //head body
        case 3:
            return 1 + curEvent.msgList.count //对话(s) + head
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
                return DetailContentCell.getCellHeight(curEvent, index: indexPath)
            case 2:
                return DetailCashCell.getCellHeight(curEvent, index: indexPath)
            default:
                return 0
            }
        case 1: //person(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailTeamHeadCell.getCellHeight()
            default:
                return DetailTeamCell.getCellHeight(curEvent, index: indexPath)
            }
        case 2: //比分(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailImageHeadCell.getCellHeight()
            default:
                return DetailImageCell.getCellHeight(curEvent, index: indexPath)
            }
        case 3: //对话(s) + head
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailMsgHeadCell.getCellHeight()
            default:
                return DetailMsgCell.getCellHeight(curEvent, index: indexPath)
            }
        default:
            return 0
        }
    }

    let imageCellId = "ICId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: curEvent, ctrlr: self) { indexPath in
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
        APP.activeEventsMgr.unregister(key: "DetailViewController")
        let _ = navigationController?.popViewController(animated: true)
    }

    // 修改event 被cell调用 changeType: C改变当前，N在当前添加，D删除当前，A所有的重刷
    func changeEvent(_ indexPath: IndexPath, changeType: String, changeFunc: (_ e: Event) -> Void ) {
        // 修改event
        changeFunc(curEvent)

        // 改变本地cell
        tableView.resetCell(type: changeType, indexs: [indexPath], d: curEvent)

        // 发送
    }

    // 虚拟键盘和输入相关
    func keyboardWillShow(note: Notification) {
        print("keyboardWillShow")
        let userInfo = (note as NSNotification).userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        isShowKeyboard = true
        textInputView.isHidden = false
        self.toolbar.isHidden = true

        let animations:(() -> Void) = {
            print(UIScreen.main.bounds.height - self.textInputView.frame.height, UIScreen.main.bounds.height, self.textInputView.frame.height)
            self.baseView.transform = CGAffineTransform(translationX: 0, y: -keyBoardBounds.size.height)
            self.textInputView.frame.origin.y = UIScreen.main.bounds.height - self.textInputView.frame.height
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

        isShowKeyboard = false
        toolbar.isHidden = false

        let animations:(() -> Void) = {
            self.baseView.transform = CGAffineTransform.identity
            self.textInputView.frame.origin.y = UIScreen.main.bounds.height
        }

        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations) { _ in
                self.textInputView.isHidden = true
            }
        }else{
            animations()
            textInputView.isHidden = true
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
            self.textInputView.frame.origin.y = UIScreen.main.bounds.height - self.textInputView.frame.height
        } else {
            self.textInputView.frame.origin.y = UIScreen.main.bounds.height
        }
    }

    func onSend(text: String) {
        perform(#selector(DetailViewController.sendMsg(text:)), with: text, afterDelay: 0.5)
    }

    func sendMsg(text: String) {
        APP.activeEventsMgr.changeData(changeFunc: { activeEvents in
            let e = getCurEvent(activeEvents)
            if e == nil {
                return
            }
            let meBrief = APP.userMgr.user.getBrief()
            let mS = MsgStruct(user: meBrief, time: Time.now, msg: text)
            e!.msgList.append(mS)
        }, needUpload: true)
    }
}
