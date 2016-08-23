//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: NavTabController, AVCaptureMetadataOutputObjectsDelegate {

    var mask: UIView! = nil
    var scanWindow: UIView! = nil
    var scanNet: UIImageView! = nil

    var session: AVCaptureSession! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // 隐藏导航栏和tabbar
        navTabType = [.HideTab, .TransparentNav]
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        view.clipsToBounds = true //这个属性必须打开否则返回的时候会出现黑边

        view.backgroundColor = UIColor.clearColor()

        initMaskView()
        initScanWindowView()
        initScanAnim()
        initScanning()
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
    }

    func initScanAnim() {
        scanNet = UIImageView(image: UIImage(named: "scan_net"))
        scanWindow.addSubview(scanNet)

        resetScanAnim()

        //不加这个的话，回到前台动画就没了
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScanViewController.resetScanAnim), name: "EnterForeground", object: nil)
    }

    func resetScanAnim() {
        scanNet.layer.removeAllAnimations()

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
    }

    func initScanning() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) //获取摄像设备
        let input: AVCaptureDeviceInput
        do {
            try input = AVCaptureDeviceInput(device: device) //创建输入流
        } catch {
            return
        }
        let output = AVCaptureMetadataOutput() //创建输出流
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue()) //设置代理 在主线程里刷新

        //设置有效扫描区域
        let scanCrop = getScanCrop(scanWindow.bounds, readerViewBounds: view.bounds)
        output.rectOfInterest = scanCrop

        //链接对象
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh //高质量采集率

        session.addInput(input)
        session.addOutput(output)

        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode] //只支持二维码，不支持条形码

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer.frame = view.layer.bounds
        view.layer.insertSublayer(layer, atIndex: 0)

        session.startRunning()
    }

    // 获取扫描区域的比例关系
    func getScanCrop(rect: CGRect, readerViewBounds: CGRect) -> CGRect {
        let readerH = CGRectGetHeight(readerViewBounds)
        let H = CGRectGetHeight(rect)
        let readerW = CGRectGetWidth(readerViewBounds)
        let W = CGRectGetWidth(rect)

        // AVCapture输出的图片大小都是横着的，而iPhone的屏幕是竖着的，那么我把它旋转90° 所以x用H，y用W
        let x = (readerH - H) / 2 / readerH
        let y = (readerW - W) / 2 / readerW

        let width = H / readerH
        let height = W / readerW

        return CGRect(x: x, y: y, width: width, height: height)
    }

    // AVCaptureMetadataOutput的回调
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            session.stopRunning()
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print(metadataObj.stringValue)
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
