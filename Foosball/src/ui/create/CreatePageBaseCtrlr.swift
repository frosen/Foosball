//
//  CreatePageBaseCtrlr.swift
//  Foosball
//
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreatePageBaseCtrlr: UIViewController {

    var rootCtrlr: CreateController! = nil
    var pageSize: CGSize! = nil

    // 之所以要传入size，是因为在viewDidload的时候，本身的size还没有被设置，所以view的size还是原始的
    init(rootCtrlr: CreateController, pageSize: CGSize) {
        super.init(nibName: nil, bundle: nil)
        self.rootCtrlr = rootCtrlr
        self.pageSize = pageSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
