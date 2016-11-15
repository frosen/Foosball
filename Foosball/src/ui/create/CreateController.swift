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

        // 位置初始化 自定义的转景，系统不会重置view的位置，所以自己来
        view.frame.origin.y += 64

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(CreateController.onBack), image: "go_back")
        view.backgroundColor = UIColor.blue
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
}






