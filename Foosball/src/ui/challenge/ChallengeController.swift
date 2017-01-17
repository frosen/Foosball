//
//  ChallengeController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeController: BaseTabController, ActiveEventsMgrObserver, UITableViewDelegate, UITableViewDataSource, BaseCellDelegate {
    private var dataPage: Int = 1
    private var tableView: UITableView! = nil

    private var curActiveEvents: [Event] = []
    private var curActiveEventsCount: Int = 0

    var selectedCell: ChallengeCell? = nil

    // 是否是在进入细节页面时，直接显示到msg处
    private(set) var isShowMsg: Bool = true

    override func viewDidLoad() {
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("挑战页面")

        //标题
        title = "测试"
        
        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none //极简风
        tableView.backgroundColor = UIColor.white

        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -3) //否则滚动条和屏幕边会有一段间隔
    }

    private let DataObKey = "ChallengeController"
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

    // ActiveEventsMgrObserver =============================================================================================

    func onInit(mgr: ActiveEventsMgr) {
        curActiveEvents = mgr.data
        curActiveEventsCount = mgr.eventCount
        tableView.reloadData()
    }

    func onModify(mgr: ActiveEventsMgr) {
        curActiveEvents = mgr.data
        curActiveEventsCount = mgr.eventCount
        tableView.reloadData()
    }

    //table view =============================================================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return curActiveEventsCount //因为要利用section的head作为留白，所以每个section就是一行数据
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //section用于记录数据了，所以其中的row数量就是1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 //数据行之间的留白
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChallengeCell.getCellHeight()
    }

    private func getEvent(by indexPath: IndexPath) -> Event {
        return curActiveEvents[curActiveEventsCount - indexPath.section - 1] // event按照时间排序，而显示要最新的再最前
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let e: Event = getEvent(by: indexPath)
        return BaseCell.create(indexPath, tableView: tableView, d: e, ctrlr: self, delegate: self)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let c = tableView.cellForRow(at: indexPath) as! ChallengeCell
        let e: Event = getEvent(by: indexPath)
        enterDetail(cell: c, id: e.ID)
    }

    // BaseCellDelegate --------------------------------------------------------------

    func getCInfo(_ indexPath: IndexPath) -> BaseCell.CInfo {
        return BaseCell.CInfo(id: "chalCellId", c: ChallengeCell.self)
    }

    // function --------------------------------------------------------------

    func enterDetail(cell: ChallengeCell, id: DataID, showMsg: Bool = false) {
        selectedCell = cell
        isShowMsg = showMsg

        let vc = DetailViewController(rootVC: rootVC, id: id, showMsg: isShowMsg)
        navigationController!.pushViewController(vc, animated: true)
    }
}
