//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: NavTabController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
        initBottomButton()

        initScanning()

        //不加这个的话，回到前台动画就没了
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ScanViewController.resetScanAnim), name: "EnterForeground", object: nil)
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

    func initBottomButton() {
        var btns: [UIButton] = []

        btns.append(setBtn(#selector(ScanViewController.onOpenAlbum), imgName: "scan_btn_photo", selectImgName: nil))
        btns.append(setBtn(#selector(ScanViewController.onPressFlash(_:)), imgName: "scan_btn_flash", selectImgName: nil))

        let btnDis = view.bounds.width / CGFloat(btns.count + 1)
        for i in 0..<btns.count {
            let x = btnDis * CGFloat(i + 1)
            let y = view.bounds.height - 50
            btns[i].center = CGPoint(x: x, y: y)
        }
    }

    func setBtn(action: Selector, imgName: String, selectImgName: String?) -> UIButton {
        let btn = UIButton(type: .Custom)
        view.addSubview(btn)
        btn.setBackgroundImage(UIImage(named: imgName), forState: .Normal)
        btn.sizeToFit()
        if selectImgName != nil {
            btn.setBackgroundImage(UIImage(named: selectImgName!), forState: .Selected)
        }
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        return btn
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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        resetScanAnim()
    }

    func resetScanAnim() {
        if scanNet == nil {
            scanNet = UIImageView(image: UIImage(named: "scan_net"))
            scanWindow.addSubview(scanNet)
        } else {
            scanNet.layer.removeAllAnimations()
        }

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

    // 各种回调---------------------------------------------------------
    func onBack() {
        navigationController?.popViewControllerAnimated(true)
    }

    func onOpenAlbum() {
        print("打开相册")
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let ctrller = UIImagePickerController()
            ctrller.delegate = self

            ctrller.sourceType = .SavedPhotosAlbum

            ctrller.modalTransitionStyle = .FlipHorizontal
            presentViewController(ctrller, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "提示", message: "设备不支持访问相册，请在设置->隐私->照片中进行设置！", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "确定", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let img: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage//获取图片
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) //初始化监视器

        picker.dismissViewControllerAnimated(true) {
            let features = detector.featuresInImage(CIImage(CGImage: img.CGImage!))
            if features.count >= 1 {
                let feature: CIQRCodeFeature = features[0] as! CIQRCodeFeature
                let scanResult = feature.messageString

                // 展示结果
                UITools.showAlert(self, title: "结果", msg: scanResult, type: 1, callback: nil)
            } else {
                UITools.showAlert(self, title: "提示", msg: "图片中并没有二维码", type: 1, callback: nil)
            }
        }
    }

    func onPressFlash(btn: UIButton) {
        print("闪光灯")

        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if device.hasTorch && device.hasFlash {
            do {
                try device.lockForConfiguration()
            } catch {
                return
            }

            btn.selected = !btn.selected
            let turnOn: Bool = btn.selected

            if turnOn == true {
                device.torchMode = .On
                device.flashMode = .On
            } else {
                device.torchMode = .Off
                device.flashMode = .Off
            }

            device.unlockForConfiguration()
        } else {
            UITools.showAlert(self, title: "提示", msg: "并没有闪光灯", type: 1, callback: nil)
        }
    }
    
}
