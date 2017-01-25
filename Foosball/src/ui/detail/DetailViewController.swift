//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, ActiveEventsMgrObserver, MsgMgrObserver, UITableViewDelegate, UITableViewDataSource, StaticCellDelegate, InputViewDelegate {

    private var sectionNum: Int = 0

    private(set) var curEventId: DataID! = nil
    private var curEvent: Event! = nil

    private(set) var msgContainer: MsgContainer? = nil

    private var isShowMsg: Bool = false

    var tableView: UITableView! = nil
    private var toolbar: BaseToolbar! = nil
    private var actBtnBoard: ActionBtnBoard! = nil
    private var textInputView: InputView! = nil
    private var isShowKeyboard: Bool = false

    private var msgHeadCellRelief: UIView! = nil // 消息头的替身，放在最上不消失

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(rootVC: RootViewController, id: DataID, showMsg: Bool) {
        super.init(rootVC: rootVC)
        self.curEventId = id
        isShowMsg = showMsg
    }
    
    override func viewDidLoad() {
        initDataOnViewAppear = true
        navTabType = .HideTab
        super.viewDidLoad()
        print("详情页面")

        title = "详情"
        UITools.createNavBackBtn(self, action: #selector(DetailViewController.onBack))

        baseView.isUserInteractionEnabled = false
        callbackOnFinishInit = { _ in
            self.baseView.isUserInteractionEnabled = true
            KeynotelikeTransitioning.hideSnapshot() //这里编码耦合度高，要注意
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
        toolbar = BaseToolbar()
        baseView.addSubview(toolbar)
        toolbar.frame.origin.y = baseView.frame.height - toolbar.frame.height

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: toolbar.frame.height, right: 0)

        actBtnBoard = ActionBtnBoard(frame: CGRect(x: 0, y: 0, width: toolbar.frame.width, height: toolbar.frame.height))
        toolbar.addSubview(actBtnBoard)

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

        // msg按钮的替身
        msgHeadCellRelief = UIView(frame: CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: DetailMsgHeadCell.getCellHeight()
        ))
        baseView.addSubview(msgHeadCellRelief)
        msgHeadCellRelief.backgroundColor = UIColor.white
        let mhcFrame = msgHeadCellRelief.frame
        DetailMsgHeadCell.createMsgHeadView(
            msgHeadCellRelief,
            s: (mhcFrame.width, mhcFrame.height),
            c: [
                (self, #selector(DetailViewController.beginInput)),
                (self, #selector(DetailViewController.beginInputScore))
            ]
        )
        msgHeadCellRelief.isHidden = true // 先隐藏

    }

    let DataObKey = "DetailViewController"
    override func initData() {
        APP.activeEventsMgr.register(observer: self, key: DataObKey)
        APP.msgMgr.register(observer: self, key: DataObKey)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP.activeEventsMgr.set(hide: false, key: DataObKey)
        APP.msgMgr.set(hide: false, key: DataObKey)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isShowMsg {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APP.activeEventsMgr.set(hide: true, key: DataObKey)
        APP.msgMgr.set(hide: true, key: DataObKey)
    }

    // cell 滑动优化相关 ==============================================================================
    private let staticVarCellIndexList = [
        IndexPath(row: 1, section: 1),
        IndexPath(row: 2, section: 1),
        IndexPath(row: 1, section: 2)
    ] // 静态cell，但是又需要通过setData变化的

    // 优化高度获取，避免每次都进行计算
    private(set) var cellHeightDict: [Int: CGFloat] = [:]
    func getCellHeightDictIndex(section: Int, row: Int) -> Int {
        return section * 1000 + row
    }

    // 优化cell的获取，配合StaticCell的needUpdate属性，只有需要更新的时候再调用，可以大幅度优化性能
    private var cellNeedUpdate: [IndexPath: Bool] = [:]

    // 在初始化的时候直接生成的cell，先放到这里
    private var holdCellDict: [IndexPath: UITableViewCell] = [:]

    // ActiveEventsMgrObserver ==============================================================================

    func onInit(actE: ActEvents) {
        guard let e = actE.getCurEvent(curId: curEventId) else {
            return
        }

        sectionNum = 4
        curEvent = e
        cellHeightDict.removeAll()

        // 预生成这些static cell，避免第一次滑动造成的卡顿
        for indexPath in staticVarCellIndexList {
            let c = StaticCell.create(indexPath, tableView: tableView, d: curEvent, ctrlr: self, delegate: self)
            holdCellDict[indexPath] = c
        }

        tableView.reloadData()

        // toolbar
        let st = APP.userMgr.getState(from: e, by: APP.userMgr.me.ID)
        actBtnBoard.setState(st)

        // 刚进来时，让更新提示消失
        APP.activeEventsMgr.clearEventChange(e)
    }

    func onModify(actE: ActEvents) {
        guard let e = actE.getCurEvent(curId: curEventId) else {
            return
        }

        curEvent = e

        tableView.beginUpdates()

        // team和瞬间的更新
        for indexPath in staticVarCellIndexList {
            cellHeightDict.removeValue(forKey: getCellHeightDictIndex(section: indexPath.section, row: indexPath.row))
            cellNeedUpdate[indexPath] = true
        }
        tableView.reloadRows(at: staticVarCellIndexList, with: .none)

        tableView.endUpdates()

        // 状态
        let st = APP.userMgr.getState(from: e, by: APP.userMgr.me.ID)
        actBtnBoard.setState(st)
        if let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailTitleCell {
            titleCell.set(state: st)
        }

        // 在显示着这个event的细节时更新，显示更新并结束提示
        if let changeTup: (Bool, Int) = APP.activeEventsMgr.eventChangeMap[e] {
            print(changeTup)
            APP.activeEventsMgr.clearEventChange(e)
        }
    }

    // MsgMgrObserver ---------------------------------------------------------------------------------

    func getCurEventID(for msgMgr: MsgMgr) -> DataID {
        return curEventId
    }

    func onModify(msgs: MsgContainer) {
        msgContainer = msgs

        let section: Int = 3
        var indexPathList: [IndexPath] = []

        let posList = msgs.insertPos

        if posList.count == 0 && msgs.msgIdList.count > 0 { // 全部
            for i in 0 ..< msgs.msgIdList.count {
                let indexPath = IndexPath(row: i + 1, section: section)
                indexPathList.append(indexPath)
            }

            // 修改高度，所以先删除原来所有高度
            var i = 1
            while true {
                let index = getCellHeightDictIndex(section: 3, row: i)
                let rmHeight = cellHeightDict.removeValue(forKey: index)
                if rmHeight == nil {
                    break
                } else {
                    i += 1
                }
            }

            // 插入新cell
            tableView.insertRows(at: indexPathList, with: .fade)
            return
        }

        for pos in posList {
            let indexPath = IndexPath(row: pos + 1, section: section) // +1 为了跳过标题
            indexPathList.append(indexPath)
        }

        if indexPathList.count == 0 {
            return
        }

        // 计算偏移量
        var p: Int = 0
        var offsetList: [Int] = [] //表示当前序号的这个值需要偏移的量
        for i in 0 ... posList.last! {
            let pos = posList[p]
            if pos == i {
                p += 1
            } else {
                offsetList.append(p)
            }
        }

        // 把cellHeightDict里面的数据往后移
        var i = 1
        var indexList: [(Int, CGFloat)] = []
        while true {
            let index = getCellHeightDictIndex(section: 3, row: i)
            guard let h = cellHeightDict[index] else {
                break
            }

            let offset = i > offsetList.count ? indexPathList.count : offsetList[i - 1]

            let tup: (Int, CGFloat) = (index + offset, h)
            indexList.append(tup)
            cellHeightDict.removeValue(forKey: index)

            i += 1
        }
        for tup in indexList {
            cellHeightDict[tup.0] = tup.1
        }

        // 重新计算msg tail cell的高度，所以要删除原来的
        let tailHIndex = getCellHeightDictIndex(section: section, row: msgs.msgIdList.count + 1)
        cellHeightDict.removeValue(forKey: tailHIndex)

        // 插入新cell
        tableView.insertRows(at: indexPathList, with: .fade)
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
            print(2 + (msgContainer?.msgIdList.count ?? 0))
            return 2 + (msgContainer?.msgIdList.count ?? 0) //对话(s) + head
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 25
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
            case (msgContainer?.msgIdList.count ?? 0) + 1:
                height = DetailMsgTailCell.getCellHeight(curEvent, index: indexPath, otherData: self)
            default:
                height = DetailMsgCell.getCellHeight(curEvent, index: indexPath, otherData: self)
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

    // scrollView delegate ---------------------------------------------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellRect = tableView.rectForRow(at: IndexPath(row: 0, section: 3))
        let cellPosForScreen = tableView.convert(cellRect.origin, to: baseView)

        // msg head 到达顶部时，显示替身
        msgHeadCellRelief.isHidden = (cellPosForScreen.y > 0)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        APP.activeEventsMgr.set(hide: true, key: DataObKey)
        APP.msgMgr.set(hide: true, key: DataObKey)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            APP.activeEventsMgr.set(hide: false, key: DataObKey)
            APP.msgMgr.set(hide: false, key: DataObKey)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        APP.activeEventsMgr.set(hide: false, key: DataObKey)
        APP.msgMgr.set(hide: false, key: DataObKey)
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
            case (msgContainer?.msgIdList.count ?? 0) + 1:
                return BaseCell.CInfo(id: "MTCId", c: DetailMsgTailCell.self)
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
        APP.activeEventsMgr.unregister(key: DataObKey)
        APP.msgMgr.unregister(key: DataObKey)
        
        NotificationCenter.default.removeObserver(self)
        let _ = navigationController?.popViewController(animated: true)
    }

    // 虚拟键盘和输入相关 =============================================================
    
    func keyboardWillShow(note: Notification) {
        print("keyboardWillShow")
        let userInfo = (note as NSNotification).userInfo!
        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue

        isShowKeyboard = true
        textInputView.isHidden = false
        self.toolbar.isHidden = true

        let animations: (() -> Void) = {
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

    func beginInputScore() {
        print("record score")
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
        let me = APP.userMgr.me
        let mS = MsgStruct(id: DataID(ID: "send"), user: me, time: Time.now, msg: text)
        APP.msgMgr.addNewMsg(mS)
//        APP.activeEventsMgr.changeData(changeFunc: { data in
//            guard let e = data.getCurEvent(curId: curEventId) else {
//                print("ERROR: no event in sendMsg changeData")
//                return nil
//            }
//
//
//            e.msgList.append(mS)
//
//            return nil
//        }, needUpload: ["msg": "add"])
    }
}
