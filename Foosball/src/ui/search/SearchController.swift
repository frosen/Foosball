//
//  SearchController.swift
//  Foosball
//
//  Created by luleyan on 2016/12/28.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class SearchController: BaseController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(SearchController.onBack), image: "go_back")
    }

    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }
}
