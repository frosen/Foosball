//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ScanViewController: NavTabController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏和tabbar
        navTabType = [.HideTab, .TransparentNav]
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.leftBarButtonItem = createBarBtnItem(#selector(ScanViewController.onBack(_:)), image: "go_back")

        view.clipsToBounds = true //这个属性必须打开否则返回的时候会出现黑边

        view.backgroundColor = UIColor.whiteColor()

        initMaskView()
    }

    func createBarBtnItem(action: Selector, image img: String) -> UIBarButtonItem {
        let btn = UIButton(type: .Custom)
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        btn.setBackgroundImage(UIImage(named: img), forState: .Normal)
        let bSize = btn.currentBackgroundImage!.size
        btn.bounds = CGRect(x: 0, y: 0, width: bSize.width, height: bSize.height)
        return UIBarButtonItem(customView: btn)
    }

    let maskMargin: CGFloat = 35.0
    func initMaskView() {
        let mask = UIView()
        view.addSubview(mask)

        let borderWidth: CGFloat = 500.0

        mask.layer.borderColor = UIColor(white: 0.0, alpha: 0.7).CGColor
        mask.layer.borderWidth = borderWidth

        let maskWidth = view.frame.width + borderWidth * 2 - maskMargin * 2
        mask.bounds = CGRect(x: 0, y: 0, width: maskWidth, height: maskWidth)
        mask.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.5)
    }

    func setBtn(action: Selector, imgName: String, centerPos: CGPoint) {
        let btn = UIButton(type: .Custom)
        view.addSubview(btn)
        btn.setBackgroundImage(UIImage(named: imgName), forState: .Normal)
        btn.sizeToFit()
        btn.center = centerPos
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
    }

    func onBack(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
