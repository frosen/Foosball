//
//  ChallengeController.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/2.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeController: BaseTableController {
    var dataPage: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        print("挑战页面")

        initNavBar()
    }

    override func viewWillAppear(animated: Bool) {
        
    }
}
