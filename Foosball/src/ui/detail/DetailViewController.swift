//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, ActiveEventsMgrObserver, MsgMgrObserver, UITableViewDelegate, UITableViewDataSource, StaticCellDelegate, InputViewDelegate {

    private let msgSectionIndex = 3

    private var sectionNum: Int = 0

    private(set) var curEventId: DataID! = nil
    private var curEvent: Event! = nil

    private(set) var msgContainer: MsgContainer? = nil
    private var firstMsg: MsgStruct? = nil
    private var tmpMsgList: MsgMgr.MsgStructList! = nil // 临时对话，用于信息发送时

    private var isShowMsgDirectly: Bool = false // 是否是进入场景时直接显示对话

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
        isShowMsgDirectly = showMsg
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

        if isShowMsgDirectly {
            tableView.scrollToRow(at: IndexPath(row: 1, section: 0), at: .top, animated: false) // 避免在一瞬间显示出已经向上移动出屏幕的head cell
            tableView.scrollToRow(at: IndexPath(row: 0, section: msgSectionIndex), at: .top, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP.activeEventsMgr.set(hide: false, key: DataObKey)
        APP.msgMgr.set(hide: false, key: DataObKey)
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
            let _ = StaticCell.create(indexPath, tableView: tableView, data: curEvent, ctrlr: self, delegate: self)
        }

        // 加载未发送成功的临时msgCell
        if APP.msgMgr.tmpMsgListDict[curEventId] == nil {
            APP.msgMgr.tmpMsgListDict[curEventId] = MsgMgr.MsgStructList()
        }
        tmpMsgList = APP.msgMgr.tmpMsgListDict[curEventId]!

        // 刷新
        tableView.reloadData()

        // toolbar
        let st = UserMgr.getState(from: e, by: APP.userMgr.me.ID)
        actBtnBoard.setState(st)

        handleEventChange()
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
        let st = UserMgr.getState(from: e, by: APP.userMgr.me.ID)
        actBtnBoard.setState(st)
        if let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailTitleCell {
            titleCell.set(state: st)
        }

        handleEventChange()
    }

    private func handleEventChange() {
        // 动画显示状态变化

        // 在显示着这个event的细节时更新，显示更新并结束提示
        APP.activeEventsMgr.clearEventChange(curEventId)
    }

    // MsgMgrObserver ---------------------------------------------------------------------------------

    func getCurEventID(for msgMgr: MsgMgr) -> DataID {
        return curEventId
    }

    func onModify(msgs: MsgContainer) {
        msgContainer = msgs

        // 获取新添加的msgId
        var newMsgs: [MsgStruct] = []
        if firstMsg == nil {
            newMsgs = msgs.msgList
        } else {
            for msgStru in msgs.msgList {
                if msgStru.ID != firstMsg!.ID {
                    newMsgs.append(msgStru)
                } else {
                    break
                }
            }
        }

        // 检查有无可以取代的临时msg，有则取代之
        var replaceCount: Int = 0
        for msgStru in newMsgs {
            if msgStru.user!.ID == APP.userMgr.me.ID {
                for i in 0 ..< tmpMsgList.list.count {
                    if msgStru.time! == tmpMsgList.list[i].time! {
                        tmpMsgList.list.remove(at: i)
                        replaceCount += 1
                        break
                    }
                }
            }
        }

        shiftMsgCellHeightDict(by: newMsgs.count - replaceCount)
        UIView.performWithoutAnimation { // 刷新列表，不加without会有奇怪的动画 http://www.cocoachina.com/bbs/read.php?tid-335336-page-2.html
            tableView.reloadSections([msgSectionIndex], with: .none)
        }

        firstMsg = msgs.msgList.first
    }

    private func shiftMsgCellHeightDict(by offset: Int) {
        var i = 1 // =1 为了跳过标题
        var indexList: [(Int, CGFloat)] = []
        while true {
            let index = getCellHeightDictIndex(section: msgSectionIndex, row: i)
            guard let h = cellHeightDict[index] else {
                break
            }

            if i > tmpMsgList.list.count { // 临时msg的高度每次都清理掉，重新获取
                let tup: (Int, CGFloat) = (index + offset, h)
                indexList.append(tup)
            }

            cellHeightDict.removeValue(forKey: index)
            i += 1
        }

        for i in 0 ..< indexList.count - 1 { // 之所以-1，是为了删除最后一个cell，也就是msg tail cell的高度，以便重新计算
            cellHeightDict[indexList[i].0] = indexList[i].1
        }
    }

    // table view delegate ==========================================================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowNum: Int
        switch section {
        case 0:
            rowNum = 5 //title + detail + wager + time + location
        case 1:
            //head 友 敌 2. 如果是乱斗应该是不分敌友的所以是2行，但暂时不考虑；3. 以后也可能加入观众，暂不考虑
            rowNum = 3 //友一定有自己，敌如果没有也有个标题表示没有的状态
        case 2:
            rowNum = 2 // head body 就算是没有图片时，也应该有个默认的图
        case 3:
            rowNum = 2 + tmpMsgList.list.count + (msgContainer?.msgList.count ?? 0) // head + tail + 临时对话(s) + 对话(s)
        default:
            rowNum = 0
        }
//        print("TTT section\(section) has \(rowNum) rows")
        return rowNum
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
//            print("TTT indexPath \(indexPath) height is \(h) (old)")
            return h
        }

        var data: BaseData = curEvent
        if s == msgSectionIndex { // msg的cell使用不同的数据源
            if let msgStru = getMsgCellData(by: r) {
                data = msgStru
            }
        }
        let height: CGFloat = (getCInfo(indexPath).cls as! BaseCell.Type).getCellHeight(data, index: indexPath, otherData: self)

        cellHeightDict[getCellHeightDictIndex(section: s, row: r)] = height
//        print("TTT indexPath \(indexPath) height is \(height)")
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data: BaseData = curEvent
        if indexPath.section == msgSectionIndex { // msg的cell使用不同的数据源
            if let msgStru = getMsgCellData(by: indexPath.row) {
                data = msgStru
            }
        }
        return StaticCell.create(indexPath, tableView: tableView, data: data, ctrlr: self, delegate: self)
    }

    private func getMsgCellData(by row: Int) -> MsgStruct? {
        if row == 0 {
            return nil
        } else if row <= tmpMsgList.list.count {
            return tmpMsgList.list[row - 1]
        } else if row == (msgContainer?.msgList.count ?? 0) + 1 + tmpMsgList.list.count {
            return nil
        } else {
            return msgContainer!.msgList[row - tmpMsgList.list.count - 1]
        }
    }

    // scrollView delegate ---------------------------------------------------------
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellRect = tableView.rectForRow(at: IndexPath(row: 0, section: msgSectionIndex))
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
            case (msgContainer?.msgList.count ?? 0) + 1 + tmpMsgList.list.count:
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

    var staticCellDict: [String: StaticCell] = [:]
    func saveStaticCell(_ cell: StaticCell, by identifier: String) {
        staticCellDict[identifier] = cell
    }

    func getStaticCell(by identifier: String) -> StaticCell? {
        return staticCellDict[identifier]
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

        // 创建的cell放入临时显示表
        shiftMsgCellHeightDict(by: 1)
        tmpMsgList.list.insert(mS, at: 0)

        // 刷新列表，不加without会有奇怪的动画 http://www.cocoachina.com/bbs/read.php?tid-335336-page-2.html
        UIView.performWithoutAnimation {
            tableView.reloadSections([msgSectionIndex], with: .none)
        }

        // 更新数据
        APP.msgMgr.addNewMsg(mS, obKey: DataObKey) { suc in

        }
    }
}
