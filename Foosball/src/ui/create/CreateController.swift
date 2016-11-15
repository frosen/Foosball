//
//  CreateController.swift
//  Foosball
//
//  Created by luleyan on 2016/11/14.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateController: BaseTabController {

    override func viewDidLoad() {
        navTabType = .HideTab
        super.viewDidLoad()
        print("创建页面")

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(CreateController.onBack), image: "go_back")
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
}






