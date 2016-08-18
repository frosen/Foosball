//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏和tabbar
        navigationController!.navigationBarHidden = true
        automaticallyAdjustsScrollViewInsets = false

        view.clipsToBounds = true //这个属性必须打开否则返回的时候会出现黑边

        view.backgroundColor = UIColor.whiteColor()


    }

    func initMaskView() {
        
    }

}
