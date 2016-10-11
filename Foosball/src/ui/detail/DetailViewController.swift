//
//  DetailViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/13.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class DetailViewController: BaseController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var tableView: UITableView! = nil
    weak var event: Event! = nil
    var sectionNum: Int = 0

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

        tableView.showsVerticalScrollIndicator = false //隐藏滑动条
//        tableView.backgroundColor = UIColor.white //最后再让背景变成白色，否则现在不易设计
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
        return StaticCell.create(indexPath, tableView: tableView, d: event, delegate: self) { indexPath in
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

    // cell的按钮回调 ===================================================================================================
    // 邀请
    func onClickInvite() {
        print("invite")
    }

    // 拍照
    func onClickPhoto() {
        print("photo")
        startImagePicker(.camera, str: "拍照设备")
    }

    func onClickAlbum() {
        print("album")
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        startImagePicker(hasCamera ? .photoLibrary : .savedPhotosAlbum, str: "相册")
    }

    func startImagePicker(_ t: UIImagePickerControllerSourceType, str: String) {
        if UIImagePickerController.isSourceTypeAvailable(t) {
            let ctrller = UIImagePickerController()
            ctrller.delegate = self
            ctrller.sourceType = t
            ctrller.allowsEditing = true
            ctrller.modalTransitionStyle = .coverVertical
            present(ctrller, animated: true, completion: nil)
        } else {
            UITools.showAlert(self, title: "提示", msg: "设备不支持访问" + str + "，请在设置->隐私中进行设置！", type: 1, callback: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)

        //预处理ui

        //获取图片
        let img: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage

        //保存在本地

        //上传图片

        //获取url

        //更新event

        //取消预处理

        //更新cell
    }

    //当点击图片时
    func onClickImageView(tag: Int) {
        print("onClickImageView", tag)
    }
}
