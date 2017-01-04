//
//  SearchController.swift
//  Foosball
//
//  Created by luleyan on 2016/12/28.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class SearchController: BaseController, UISearchBarDelegate {

    var search: UISearchBar! = nil

    override func viewDidLoad() {
        navTabType = .HideTab
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(SearchController.onBack), image: #imageLiteral(resourceName: "go_back"))

        search = UISearchBar()
        navigationItem.titleView = search

        search.placeholder = "搜索"
        search.delegate = self

        // 点击画面收起输入框
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchController.endInput))
        view.addGestureRecognizer(tap)
    }

    override func viewDidAppear(_ animated: Bool) {
        search.becomeFirstResponder()
    }

    func onBack() {
        endInput()
        let _ = navigationController?.popViewController(animated: true)
    }

    func endInput() {
        search.resignFirstResponder()
    }
}
