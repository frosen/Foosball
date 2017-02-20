//
//  PersonalInfoController.swift
//  Foosball
//
//  Created by luleyan on 2017/1/11.
//  Copyright © 2017年 卢乐颜. All rights reserved.
//

import UIKit

class PersonalInfoController: BaseController {
    override func viewDidLoad() {
        navTabType = .HideTab // 隐藏tabbar
        super.viewDidLoad()

        title = "编辑个人资料"
        UITools.createNavBackBtn(self, action: #selector(PersonalInfoController.onBack))
    }

    func onBack() {
        let _ = navigationController!.popViewController(animated: true)
    }
}
