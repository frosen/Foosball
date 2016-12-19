//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, ActiveEventsMgrObserver, UITableViewDelegate, UITableViewDataSource, InputViewDelegate {

    private var curEventId: DataID! = nil
    private var curEvent: Event! = nil
    private var sectionNum: Int = 0

    var tableView: UITableView! = nil
    private var toolbar: Toolbar! = nil
    private var textInputView: InputView! = nil
    private var isShowKeyboard: Bool = false

    func setDataId(_ id: DataID) {
        self.curEventId = id
    }
    
    override func viewDidLoad() {
        initDataOnViewAppear = true
        navTabType = .HideTab
        super.viewDidLoad()
        print("详情页面")

        title = "详情"

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        baseView.isUserInteractionEnabled = false
        callbackOnFinishInit = { _ in
            self.baseView.isUserInteractionEnabled = true
            KeynotelikeTransitioning.hideSnapshot() //这里编码十分耦合，要注意
        }

        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorInset = UIEdgeInsets(top: 0, left: DetailG.headMargin, bottom: 0, right: DetailG.headMargin)
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条
//        tableView.backgroundColor = UIColor.white //最后再让背景变成白色，否则现在不易设计

        //按钮栏
        toolbar = Toolbar()
        baseView.addSubview(toolbar)

        toolbar.btn1.setTitle("ppp", for: .normal)
        toolbar.btn2.setTitle("ggg", for: .normal)

        toolbar.frame.origin.y = baseView.frame.height - toolbar.frame.height
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolbar.frame.height, right: 0)

        //隐藏在最下面的输入栏
        textInputView = InputView()
        baseView.addSubview(textInputView)
        textInputView.delegate = self

        // 初始化时，y为总高是为了隐藏到最底下，并且隐藏
        textInputView.frame.origin.y = baseView.frame.height
        textInputView.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillShow), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyBoardWillHide), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)

        let tap = UITapGestureRecognizer(target: self, action: #selector(DetailViewController.endInput(ges:)))
        baseView.addGestureRecognizer(tap)
        
    }

    private let DataObKey = "DetailViewController"
    override func initData() {
        APP.activeEventsMgr.register(observer: self, key: DataObKey)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP.activeEventsMgr.set(hide: false, key: DataObKey)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APP.activeEventsMgr.set(hide: true, key: DataObKey)
    }

    // ActiveEventsMgrObserver ==============================================================================

    func onInit(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            sectionNum = 4
            curEvent = e
            tableView.reloadData()
            saveNewestMsg(e.msgList[e.msgList.count - 1]) // 记录最新的msg
        }
    }

    func onModify(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            curEvent = e

            tableView.beginUpdates()

            // team和瞬间的更新
            let indexList = [
                IndexPath(row: 1, section: 1),
                IndexPath(row: 2, section: 1),
                IndexPath(row: 1, section: 2)
            ]
            tableView.reloadRows(at: indexList, with: .none)

            // 前几个不是上次记录的最新的对话，展示在ui上
            var i = e.msgList.count - 1
            var resetRow: Int = 1
            while true {
                let msg = e.msgList[i]
                if !isNewestMsg(msg) {
                    tableView.insertRows(at: [IndexPath(row: resetRow, section: 3)], with: .fade)
                    resetRow += 1
                } else {
                    break
                }

                i -= 1
                if i < 0 {
                    break
                }
            }
            tableView.endUpdates()

            saveNewestMsg(e.msgList[e.msgList.count - 1]) // 记录最新的msg
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

    // 记录最新的对话，方便更新对话列表
    private var newestMsgUserId: DataID? = nil
    private var newestMsgTime: Time? = nil
    private func saveNewestMsg(_ msg: MsgStruct) {
        newestMsgUserId = msg.user.ID
        newestMsgTime = msg.time
    }

    private func isNewestMsg(_ msg: MsgStruct) -> Bool {
        if newestMsgUserId == nil || newestMsgTime == nil {
            return true // 没有记录时，都是最新的
        } else {
            return msg.user.ID == newestMsgUserId! && msg.time == newestMsgTime!
        }
    }

    // table view delegate ==========================================================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5 //title + detail + wager + time + location
        case 1:
            //head 友 敌 2. 如果是乱斗应该是不分敌友的所以是2行，但暂时不考虑；3. 以后也可能加入观众，暂不考虑
            return 3 //友一定有自己，敌如果没有也有个标题表示没有的状态
        case 2:
            return 2 // head body 就算是没有图片时，也应该有个默认的图
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
        case 0: //title + detail + wager
            switch (indexPath as NSIndexPath).row {
            case 0:
                return DetailTitleCell.getCellHeight()
            case 1:
                return DetailContentCell.getCellHeight(curEvent, index: indexPath)
            case 2:
                return DetailWagerCell.getCellHeight(curEvent, index: indexPath)
            case 3:
                return DetailTimeCell.getCellHeight(curEvent, index: indexPath)
            case 4:
                return DetailLocationCell.getCellHeight(curEvent, index: indexPath)
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return StaticCell.create(indexPath, tableView: tableView, d: curEvent, ctrlr: self) { indexPath in
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return BaseCell.CInfo(id: "TitCId", c: DetailTitleCell.self)
                case 1:
                    return BaseCell.CInfo(id: "ConCId", c: DetailContentCell.self)
                case 2:
                    return BaseCell.CInfo(id: "HonCId", c: DetailWagerCell.self)
                case 3:
                    return BaseCell.CInfo(id: "TimCId", c: DetailTimeCell.self)
                default:
                    return BaseCell.CInfo(id: "LocCId", c: DetailLocationCell.self)
                }
            case 1:
                switch indexPath.row {
                case 0:
                    return BaseCell.CInfo(id: "THCId", c: DetailTeamHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "TCId", c: DetailTeamCell.self)
                }
            case 2:
                switch indexPath.row {
                case 0:
                    return BaseCell.CInfo(id: "IHCId", c: DetailImageHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "ICId", c: DetailImageCell.self)
                }
            default:
                switch indexPath.row {
                case 0:
                    return BaseCell.CInfo(id: "MHCId", c: DetailMsgHeadCell.self)
                default:
                    return BaseCell.CInfo(id: "MCId", c: DetailMsgCell.self)
                }
            }
        }
    }

    // 回调 ==================================================================================================================
    func onBack() {
        APP.activeEventsMgr.unregister(key: "DetailViewController")
        let _ = navigationController?.popViewController(animated: true)
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
            self.textInputView.frame.origin.y = self.baseView.frame.height - self.textInputView.frame.height
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
            self.textInputView.frame.origin.y = self.baseView.frame.height
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
            self.textInputView.frame.origin.y = baseView.frame.height - self.textInputView.frame.height
        } else {
            self.textInputView.frame.origin.y = baseView.frame.height
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
            let meBrief = APP.userMgr.data.getBrief()
            let mS = MsgStruct(user: meBrief, time: Time.now, msg: text)
            e!.msgList.append(mS)
        }, needUpload: true)
    }
}
