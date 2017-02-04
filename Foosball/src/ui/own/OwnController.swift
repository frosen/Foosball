//
//  OwnController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

struct NorCellData {
    let img: UIImage
    let title: String
    let subTitle: String
    init(i: UIImage, t: String, st: String) {
        img = i
        title = t
        subTitle = st
    }
}

class OwnController: BaseTabController, UserMgrObserver, UITableViewDelegate, UITableViewDataSource, BaseCellDelegate, InfoHeadViewDelegate {
    //信息头，比赛成绩，QR，其他项目等group
    private let headCellNum: Int = 1
    private let group = [
        //section
        [
            NorCellData(i: #imageLiteral(resourceName: "share"), t: "福利", st: ""),
        ],
        [
            NorCellData(i: #imageLiteral(resourceName: "share"), t: "分享", st: "分享"),
            NorCellData(i: #imageLiteral(resourceName: "feedback"), t: "反馈", st: ""),
        ],
        [
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "账号", st: ""),
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "隐私", st: ""),
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "消息提醒", st: ""),
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "其他设置", st: ""),
        ],
        [
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "关于", st: ""),
            NorCellData(i: #imageLiteral(resourceName: "setting"), t: "版本信息", st: ""),
        ],
        [
            NorCellData(i: #imageLiteral(resourceName: "share"), t: "退出", st: ""),
        ],
    ]

    private var infoHead: InfoHeadView! = nil
    private var tableView: UITableView! = nil
    private var sectionNum: Int = 0

    private var curUser: User! = nil

    override func viewDidLoad() {
        initDataOnViewAppear = true
        navTabType = .TransparentNav //隐藏导航栏，并让tableview位置忽略导航栏
        super.viewDidLoad()
        print("个人页面")

        //创建tableView
        tableView = UITableView(frame: baseView.bounds, style: .grouped)
        baseView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0) //下面空出一些像素

        //设置tableview的基本属性，分割线等
//        tableView.separatorInset = UIEdgeInsets.zero
        tableView.showsVerticalScrollIndicator = false //隐藏滑动条

        //添加信息头
        infoHead = InfoHeadView(scrollView: tableView, extraHeight: 20)
        infoHead.delegate = self
        baseView.insertSubview(infoHead, aboveSubview: tableView)
    }

    private let DataObKey = "OwnController"
    override func initData() {
        APP.userMgr.register(observer: self, key: DataObKey)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APP.userMgr.set(hide: false, key: DataObKey)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        APP.userMgr.set(hide: true, key: DataObKey)
    }

    // observer ---------------------------------------------------------------------------------------------------

    func onInit(user: User) {
        curUser = user

        infoHead.resetData(
            bgImg: #imageLiteral(resourceName: "selfbg"),
            avatarURL: curUser.avatarURL,
            titleStr: curUser.name,
            subTitleStr: curUser.sign
        )

        sectionNum = headCellNum + group.count
        tableView.reloadData()
    }

    func onModify(user: User) {
        curUser = user

        infoHead.resetData(
            bgImg: #imageLiteral(resourceName: "selfbg"),
            avatarURL: curUser.avatarURL,
            titleStr: curUser.name,
            subTitleStr: curUser.sign
        )
    }

    // table view ---------------------------------------------------------------------------------------------------

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        default:
            return group[section - headCellNum].count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (section == 0) ? 0.1 : 10
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath as NSIndexPath).section {
        case 0:
            if (indexPath as NSIndexPath).row == 0 {
                return OwnScoreCell.getCellHeight()
            } else {
                return OwnRankCell.getCellHeight()
            }
        default:
            return OwnNormalCell.getCellHeight()
        }
    }

    private let ownNorCellId = "ONorCId"
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return BaseCell.create(indexPath, tableView: tableView, data: curUser, ctrlr: self, delegate: self)
        } else {
            var cell: UITableViewCell?
            cell = tableView.dequeueReusableCell(withIdentifier: ownNorCellId)
            if cell == nil {
                cell = OwnNormalCell(id: ownNorCellId)
            }
            let data: NorCellData = group[indexPath.section - headCellNum][indexPath.row]
            let norCell = cell as! OwnNormalCell
            norCell.setUIData(image: data.img, title: data.title, subTitle: data.subTitle)
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    // BaseCellDelegate --------------------------------------------------------------

    func getCInfo(_ indexPath: IndexPath) -> BaseCell.CInfo {
        assert(indexPath.section == 0, "wrong section in own ctrl getCInfo")
        switch indexPath.row {
        case 0:
            return BaseCell.CInfo(id: "OScoCId", c: OwnScoreCell.self)
        default:
            return BaseCell.CInfo(id: "ORankCId", c: OwnRankCell.self)
        }
    }

    // InfoHeadViewDelegate --------------------------------------------------------------

    func onClickInfoHeadViewAvatar() {
        
    }
}

















