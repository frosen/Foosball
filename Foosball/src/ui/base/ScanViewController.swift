//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ScanViewController: NavTabController {

    var mask: UIView! = nil
    var scanWindow: UIView! = nil
    var scanNet: UIImageView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏和tabbar
        navTabType = [.HideTab, .TransparentNav]
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        view.clipsToBounds = true //这个属性必须打开否则返回的时候会出现黑边

        view.backgroundColor = UIColor.whiteColor()

        initMaskView()
        initScanWindowView()
    }

    let maskMargin: CGFloat = 35.0
    func initMaskView() {
        mask = UIView()
        view.addSubview(mask)

        let borderWidth: CGFloat = 500.0

        mask.layer.borderColor = UIColor(white: 0.0, alpha: 0.7).CGColor
        mask.layer.borderWidth = borderWidth

        let maskWidth = view.frame.width + borderWidth * 2 - maskMargin * 2
        mask.bounds = CGRect(x: 0, y: 0, width: maskWidth, height: maskWidth)
        mask.center = CGPoint(x: view.frame.width * 0.5, y: view.frame.height * 0.5)
    }

    func initScanWindowView() {
        let scanWidth = view.frame.width - maskMargin * 2
        let scanRect = CGRect(x: mask.center.x - scanWidth / 2, y: mask.center.y - scanWidth / 2, width: scanWidth, height: scanWidth)

        scanWindow = UIView(frame: scanRect)
        view.addSubview(scanWindow)
        scanWindow.clipsToBounds = true

        //角上的图
        let cornerImage = UIImage(named: "scan_corner")

        let corner1 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner1)
        corner1.sizeToFit()
        corner1.frame.origin = CGPoint(x: 0, y: 0)

        let corner2 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner2)
        corner2.sizeToFit()
        corner2.frame.origin = CGPoint(x: scanWidth - corner2.frame.width, y: 0)
        corner2.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 0.5))

        let corner3 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner3)
        corner3.sizeToFit()
        corner3.frame.origin = CGPoint(x: scanWidth - corner2.frame.width, y: scanWidth - corner2.frame.height)
        corner3.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 1))

        let corner4 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner4)
        corner4.sizeToFit()
        corner4.frame.origin = CGPoint(x: 0, y: scanWidth - corner2.frame.height)
        corner4.transform = CGAffineTransformMakeRotation(CGFloat(M_PI * 1.5))

        // 扫描网
        scanNet = UIImageView(image: UIImage(named: "scan_net"))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScanViewController.resumeAnim), name: "EnterForeground", object: nil)
    }

    override func viewWillAppear(animated: Bool) {
        resumeAnim()
    }

    func resumeAnim() {
        let layer = scanNet.layer
        let anim = layer.animationForKey("translationAnimation")
        if anim == nil {
            let scanNetH: CGFloat = 241
            let scanWindowH = scanWindow.frame.height
            let scanNetW = scanWindowH

            scanNet.frame = CGRect(x: 0, y: -scanNetH, width: scanNetW, height: scanNetH)
            let scanAnim = CABasicAnimation()
            scanAnim.keyPath = "transform.translation.y"
            scanAnim.byValue = scanWindowH + scanNetH + 200
            scanAnim.duration = 2.2
            scanAnim.repeatCount = MAXFLOAT
            scanNet.layer.addAnimation(scanAnim, forKey: "translationAnimation")

            scanWindow.addSubview(scanNet)
        } else {
            let pauseTime = layer.timeOffset // 1. 将动画的时间偏移量作为暂停时的时间点
            let beginTime = CACurrentMediaTime() - pauseTime // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正

            layer.timeOffset = 0.0 // 3. 要把偏移时间清零
            layer.beginTime = beginTime // 4. 设置图层的开始动画时间
            layer.speed = 1.0
        }
    }

    func setBtn(action: Selector, imgName: String, centerPos: CGPoint) {
        let btn = UIButton(type: .Custom)
        view.addSubview(btn)
        btn.setBackgroundImage(UIImage(named: imgName), forState: .Normal)
        btn.sizeToFit()
        btn.center = centerPos
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
    }

    func onBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
}
