//
//  MsgMgr.swift
//  Foosball
//
//  Created by luleyan on 2017/1/23.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class MsgContainer {
    // 每个event对应其对话列表和这个对话是否已经被下载
    var msgList: [(MsgStruct, Bool)] = []

    // 已经保持的msg的数量
    var msgNum: Int = 20
}

typealias MsgContainerList = [DataID.IDType: MsgContainer]

protocol MsgMgrObserver {
    func getCurEventID() -> DataID
    func onModify(msgs: MsgContainerList)
}

class MsgMgr: DataMgr<MsgContainerList, MsgMgrObserver>, ActiveEventsMgrObserver {

    static var attrisKeeper: [String: Any] = [
        "id": "id",
        "user": "userid",
        "tm": "Date",
        "msg": "str"
    ]

    var curEventID: DataID? = nil

    override init() {
        super.init()
        print("初始化 MsgMgr")


        data = [:]
    }

    // set ob --------------------------------------------------
    let DataObKey = "DataMgr"

    override func unregister(key: String) {
        super.unregister(key: key)
        if obDict.count == 0 {
            APP.activeEventsMgr.unregister(key: DataObKey)
        }
    }

    override func initObserver(_ ob: MsgMgrObserver) {
        curEventID = ob.getCurEventID()

        // 注册成为 act events的观察者，当其有变化时，检测是否是当前event的msg的变化
        APP.activeEventsMgr.register(observer: self, key: DataObKey)

    }

    // 从act events获取对应事件的msg id 与数据表中比较，前20个里面没有下载的则开启下载
    override func modifyObserver(_ ob: MsgMgrObserver) {
        ob.onModify(msgs: data)
    }

    // ---------------------------------------------------------

    func onInit(actE: ActEvents) {
        if let e = actE.getCurEvent(curId: curEventID!) {
            handleMsgIds(e.msgIDList)
        }
    }

    func onModify(actE: ActEvents) {
        if let e = actE.getCurEvent(curId: curEventID!) {
            handleMsgIds(e.msgIDList)
        }
    }

    func handleMsgIds(_ ids: [DataID.IDType]) {
        var msgContainer = data[curEventID!.ID]
        var downIDList: [DataID.IDType] = []

        if msgContainer == nil {
            let newMsgC = MsgContainer()

            let totalNum = min(ids.count, newMsgC.msgNum)
            for i in (0 ..< totalNum).reversed() {
                let id = ids[i]
                let msgStru = MsgStruct(ID: DataID(ID: id))
                newMsgC.msgList.append((msgStru, false))
                downIDList.append(id)
            }

            data[curEventID!.ID] = newMsgC
            msgContainer = newMsgC
        }

        downloadMsgs(downIDList, container: msgContainer!)
    }

    func downloadMsgs(_ downIDList: [DataID.IDType], container: MsgContainer) {
        Network.shareInstance.updateObjs(from: MsgStruct.classname, ids: downIDList, into: &MsgMgr.attrisKeeper, with: []) { str, attris in
            if str == nil {
                print("ERROR: downloadMsgs wrong")
                APP.errorMgr.hasError()

            } else if str == "" {
                self.resetMsg(in: container, by: attris["id"] as! String, attris: attris)

            } else if str == "end" {
                if APP.userMgr.hasUnfetchUsers() {
                    APP.userMgr.fetchUnfetchUsers { suc in
                        if suc {
                            self.updateObserver()
                        } else {
                            APP.errorMgr.hasError()
                        }
                    }
                } else {
                    self.updateObserver()
                }
            }
        }
    }

    func resetMsg(in c: MsgContainer, by id: String, attris: [String: Any]) {
        let list = c.msgList
    }

//    func onModify(actE: ActEvents) {
//        guard let e = getCurEvent(events: actE.eList, totalEventsCount: actE.count) else {
//            return
//        }
//
//        curEvent = e
//
//        tableView.beginUpdates()
//
//        // team和瞬间的更新
//        for indexPath in staticVarCellIndexList {
//            cellHeightDict.removeValue(forKey: getCellHeightDictIndex(section: indexPath.section, row: indexPath.row))
//            cellNeedUpdate[indexPath] = true
//        }
//        tableView.reloadRows(at: staticVarCellIndexList, with: .none)
//
//        let resetRowList = getNeedAddMsgCellIndex(e.msgList)
//        let addRowCount = resetRowList.count
//        if addRowCount > 0 {
//            // 把cellHeightDict里面的数据往后移
//            var i = 1
//            var indexList: [(Int, CGFloat)] = []
//            while true {
//                let index = getCellHeightDictIndex(section: 3, row: i)
//                guard let h = cellHeightDict[index] else {
//                    break
//                }
//
//                let tup: (Int, CGFloat) = (index + addRowCount, h)
//                indexList.append(tup)
//                cellHeightDict.removeValue(forKey: index)
//
//                i += 1
//            }
//            for tup in indexList {
//                cellHeightDict[tup.0] = tup.1
//            }
//
//            // 重新计算msg tail cell的高度
//            let msgTailCellIndex = IndexPath(row: e.msgList.count + 1, section: 3)
//            let msgTailCellHeightIndex = getCellHeightDictIndex(section: msgTailCellIndex.section, row: msgTailCellIndex.row)
//            cellHeightDict[msgTailCellHeightIndex] = DetailMsgTailCell.getCellHeight(e, index: msgTailCellIndex, otherData: self)
//
//            // 插入新cell
//            tableView.insertRows(at: resetRowList, with: .fade)
//        }
//        tableView.endUpdates()
//
//        saveNewestMsg(e.msgList)
//
//        // 状态
//        let st = APP.userMgr.getState(from: e, by: APP.userMgr.me.ID)
//        actBtnBoard.setState(st)
//        if let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailTitleCell {
//            titleCell.set(state: st)
//        }
//
//        // 在显示着这个event的细节时更新，显示更新并结束提示
//        if let changeTup: (Bool, Int) = APP.activeEventsMgr.eventChangeMap[e] {
//            print(changeTup)
//            APP.activeEventsMgr.clearEventChange(e)
//        }
//    }
}
