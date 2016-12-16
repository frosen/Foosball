//
//  MapController.swift
//  Foosball
//
//  Created by luleyan on 2016/12/16.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class MapController: BaseController {

    override func viewDidLoad() {
        navTabType = .HideTab
        super.viewDidLoad()
        print("挑战页面")

        //标题
        title = "地图"
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        let map = MAMapView(frame: baseView.bounds)
        baseView.addSubview(map)
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
}
