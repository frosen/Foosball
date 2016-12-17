//
//  ChallengeController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeController: BaseTabController, ActiveEventsMgrObserver, UITableViewDelegate, UITableViewDataSource {
    private var dataPage: Int = 1
    private var tableView: UITableView! = nil

    private var curActiveEvents: [Event] = []

    var selectedCell: ChallengeCell? = nil

    override func viewDidLoad() {
        initDataOnViewAppear = true
        super.viewDidLoad()
        print("挑战页面")

        //标题
        title = "兑现"
        
        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.separatorStyle = .none //不用他的分割线，自己画

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

    func onInit(activeEvents: [Event]) {
        curActiveEvents = activeEvents
        tableView.reloadData()
    }

    func onModify(activeEvents: [Event]) {
        curActiveEvents = activeEvents
        tableView.reloadData()
    }

    //table view =============================================================================================

    func numberOfSections(in tableView: UITableView) -> Int {
        return curActiveEvents.count //因为要利用section的head作为留白，所以每个section就是一行数据
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //section用于记录数据了，所以其中的row数量就是1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5 //数据行之间的留白
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChallengeCell.getCellHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let e: Event = curActiveEvents[indexPath.section]
        return BaseCell.create(indexPath, tableView: tableView, d: e, ctrlr: self) { indexPath in
            return BaseCell.CInfo(id: "chalCellId", c: ChallengeCell.self)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = tableView.cellForRow(at: indexPath) as? ChallengeCell

        let vc = DetailViewController(rootVC: rootVC)
        let e: Event = curActiveEvents[indexPath.section]
        vc.setDataId(e.ID)
        navigationController!.pushViewController(vc, animated: true)
    }
}
