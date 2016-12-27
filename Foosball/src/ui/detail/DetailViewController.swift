//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, ActiveEventsMgrObserver, UITableViewDelegate, UITableViewDataSource, StaticCellDelegate, DetailToolbarDelegate, InputViewDelegate {

    private var curEventId: DataID! = nil
    private var curEvent: Event! = nil
    private var sectionNum: Int = 0

    var tableView: UITableView! = nil
    private var toolbar: DetailToolbar! = nil
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

        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条
        tableView.backgroundColor = UIColor.white

        //按钮栏
        toolbar = DetailToolbar()
        baseView.addSubview(toolbar)
        toolbar.delegate = self
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

    // cell 滑动优化相关 ==============================================================================
    private let staticVarCellIndexList = [
        IndexPath(row: 1, section: 1),
        IndexPath(row: 2, section: 1),
        IndexPath(row: 1, section: 2)
    ] // 静态cell，但是又需要通过setData变化的

    // 优化高度获取，避免每次都进行计算
    private var cellHeightDict: [Int: CGFloat] = [:]
    private func getCellHeightDictIndex(section: Int, row: Int) -> Int {
        return section * 1000 + row
    }

    // 优化cell的获取，配合StaticCell的needUpdate属性，只有需要更新的时候再调用，可以大幅度优化性能
    private var cellNeedUpdate: [IndexPath: Bool] = [:]

    // 在初始化的时候直接生成的cell，先放到这里
    private var holdCellDict: [IndexPath: UITableViewCell] = [:]

    // ActiveEventsMgrObserver ==============================================================================

    func onInit(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            sectionNum = 4
            curEvent = e
            cellHeightDict.removeAll()

            // 预生成这些static cell，避免第一次滑动造成的卡顿
            for indexPath in staticVarCellIndexList {
                let c = StaticCell.create(indexPath, tableView: tableView, d: curEvent, ctrlr: self, delegate: self)
                holdCellDict[indexPath] = c
            }
            
            tableView.reloadData()
            saveNewestMsg(e.msgList[e.msgList.count - 1]) // 记录最新的msg
        }
    }

    func onModify(activeEvents: [Event]) {
        if let e = getCurEvent(activeEvents) {
            curEvent = e

            tableView.beginUpdates()

            // team和瞬间的更新
            for indexPath in staticVarCellIndexList {
                cellHeightDict.removeValue(forKey: getCellHeightDictIndex(section: indexPath.section, row: indexPath.row))
                cellNeedUpdate[indexPath] = true
            }
            tableView.reloadRows(at: staticVarCellIndexList, with: .none)

            // 前几个不是上次记录的最新的对话，展示在ui上
            var i = e.msgList.count - 1
            var resetRow: Int = 1
            var resetRowList: [IndexPath] = []
            while true {
                let msg = e.msgList[i]
                if !isNewestMsg(msg) {
                    resetRowList.append(IndexPath(row: resetRow, section: 3))
                    resetRow += 1
                } else {
                    break
                }

                i -= 1
                if i < 0 {
                    break
                }
            }

            let addRowCount = resetRowList.count
            if addRowCount > 0 {
                // 把cellHeightDict里面的数据往后移
                var i = 1
                var indexList: [(Int, CGFloat)] = []
                while true {
                    let index = getCellHeightDictIndex(section: 3, row: i)
                    guard let h = cellHeightDict[index] else {
                        break
                    }

                    let tup: (Int, CGFloat) = (index + addRowCount, h)
                    indexList.append(tup)
                    cellHeightDict.removeValue(forKey: index)

                    i += 1
                }
                for tup in indexList {
                    cellHeightDict[tup.0] = tup.1
                }

                // 插入新cell
                tableView.insertRows(at: resetRowList, with: .fade)
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
        return section == 0 ? 0.1 : 25
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let s = indexPath.section
        let r = indexPath.row
        if let h = cellHeightDict[getCellHeightDictIndex(section: s, row: r)] {
            return h
        }

        var height: CGFloat

        switch s {
        case 0: //title + detail + wager
            switch r {
            case 0:
                height = DetailTitleCell.getCellHeight()
            case 1:
                height = DetailContentCell.getCellHeight(curEvent, index: indexPath)
            case 2:
                height = DetailWagerCell.getCellHeight(curEvent, index: indexPath)
            case 3:
                height = DetailTimeCell.getCellHeight(curEvent, index: indexPath)
            case 4:
                height = DetailLocationCell.getCellHeight(curEvent, index: indexPath)
            default:
                height = 0
            }
        case 1: //person(s) + head
            switch r {
            case 0:
                height = DetailTeamHeadCell.getCellHeight()
            default:
                height = DetailTeamCell.getCellHeight(curEvent, index: indexPath)
            }
        case 2: //比分(s) + head
            switch r {
            case 0:
                height = DetailImageHeadCell.getCellHeight()
            default:
                height = DetailImageCell.getCellHeight(curEvent, index: indexPath)
            }
        case 3: //对话(s) + head
            switch r {
            case 0:
                height = DetailMsgHeadCell.getCellHeight()
            default:
                height = DetailMsgCell.getCellHeight(curEvent, index: indexPath)
            }
        default:
            height = 0
        }
        cellHeightDict[getCellHeightDictIndex(section: s, row: r)] = height
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let c = holdCellDict[indexPath] {
            holdCellDict.removeValue(forKey: indexPath)
            return c
        } else {
            return StaticCell.create(indexPath, tableView: tableView, d: curEvent, ctrlr: self, delegate: self)
        }
    }

    // BaseCellDelegate --------------------------------------------------------------

    func getCInfo(_ indexPath: IndexPath) -> BaseCell.CInfo {
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
            case 1: // 因为是静态cell，需要保证每个对应唯一的id
                return BaseCell.CInfo(id: "THCId-self", c: DetailTeamCell.self)
            case 2:
                return BaseCell.CInfo(id: "THCId-op", c: DetailTeamCell.self)
            default:
                return BaseCell.CInfo(id: "TCId-other", c: DetailTeamCell.self)
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

    func getIfUpdate(_ indexPath: IndexPath) -> Bool {
        if let need = cellNeedUpdate[indexPath] {
            if need == true {
                cellNeedUpdate[indexPath] = false
                return true
            }
        }
        return false
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
