//
//  ScanViewController.swift
//  Foosball
//
//  Created by luleyan on 16/8/18.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: BaseController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var mask: UIView! = nil
    private var scanWindow: UIView! = nil
    private var scanNet: UIImageView! = nil

    private var session: AVCaptureSession! = nil

    override func viewDidLoad() {
        navTabType = [.HideTab, .TransparentNav] // 隐藏导航栏和tabbar
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UITools.createBarBtnItem(self, action: #selector(ScanViewController.onBack), image: "go_back")

        baseView.clipsToBounds = true //这个属性必须打开否则返回的时候会出现黑边

        initMaskView()
        initScanWindowView()
        initBottomButton()

        initScanning()

        //不加这个的话，回到前台动画就没了
        NotificationCenter.default.addObserver(self, selector: #selector(ScanViewController.resetScanAnim), name: NSNotification.Name(rawValue: "EnterForeground"), object: nil)
    }

    private let maskMargin: CGFloat = 35.0
    private func initMaskView() {
        mask = UIView()
        baseView.addSubview(mask)

        let borderWidth: CGFloat = 500.0

        mask.layer.borderColor = UIColor(white: 0.0, alpha: 0.7).cgColor
        mask.layer.borderWidth = borderWidth

        let maskWidth = baseView.frame.width + borderWidth * 2 - maskMargin * 2
        mask.bounds = CGRect(x: 0, y: 0, width: maskWidth, height: maskWidth)
        mask.center = CGPoint(x: baseView.frame.width * 0.5, y: baseView.frame.height * 0.5)
    }

    private func initScanWindowView() {
        let scanWidth = baseView.frame.width - maskMargin * 2
        let scanRect = CGRect(x: mask.center.x - scanWidth / 2, y: mask.center.y - scanWidth / 2, width: scanWidth, height: scanWidth)

        scanWindow = UIView(frame: scanRect)
        baseView.addSubview(scanWindow)
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
        corner2.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 0.5))

        let corner3 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner3)
        corner3.sizeToFit()
        corner3.frame.origin = CGPoint(x: scanWidth - corner2.frame.width, y: scanWidth - corner2.frame.height)
        corner3.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 1))

        let corner4 = UIImageView(image: cornerImage)
        scanWindow.addSubview(corner4)
        corner4.sizeToFit()
        corner4.frame.origin = CGPoint(x: 0, y: scanWidth - corner2.frame.height)
        corner4.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI * 1.5))
    }

    private func initBottomButton() {
        var btns: [UIButton] = []

        btns.append(setBtn(#selector(ScanViewController.onOpenAlbum), imgName: "scan_btn_photo", selectImgName: nil))
        btns.append(setBtn(#selector(ScanViewController.onPressFlash(_:)), imgName: "scan_btn_flash", selectImgName: nil))

        let btnDis = baseView.bounds.width / CGFloat(btns.count + 1)
        for i in 0..<btns.count {
            let x = btnDis * CGFloat(i + 1)
            let y = baseView.bounds.height - 50
            btns[i].center = CGPoint(x: x, y: y)
        }
    }

    private func setBtn(_ action: Selector, imgName: String, selectImgName: String?) -> UIButton {
        let btn = UIButton(type: .custom)
        baseView.addSubview(btn)
        btn.setBackgroundImage(UIImage(named: imgName), for: UIControlState())
        btn.sizeToFit()
        if selectImgName != nil {
            btn.setBackgroundImage(UIImage(named: selectImgName!), for: .selected)
        }
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    private func initScanning() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) //获取摄像设备
        let input: AVCaptureDeviceInput
        do {
            try input = AVCaptureDeviceInput(device: device) //创建输入流
        } catch {
            return
        }
        let output = AVCaptureMetadataOutput() //创建输出流
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) //设置代理 在主线程里刷新

        //设置有效扫描区域
        let scanCrop = getScanCrop(scanWindow.bounds, readerViewBounds: baseView.bounds)
        output.rectOfInterest = scanCrop

        //链接对象
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetHigh //高质量采集率

        session.addInput(input)
        session.addOutput(output)

        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode] //只支持二维码，不支持条形码

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer?.frame = baseView.layer.bounds
        baseView.layer.insertSublayer(layer!, at: 0)

        session.startRunning()
    }

    // 获取扫描区域的比例关系
    private func getScanCrop(_ rect: CGRect, readerViewBounds: CGRect) -> CGRect {
        let readerH = readerViewBounds.height
        let H = rect.height
        let readerW = readerViewBounds.width
        let W = rect.width

        // AVCapture输出的图片大小都是横着的，而iPhone的屏幕是竖着的，那么我把它旋转90° 所以x用H，y用W
        let x = (readerH - H) / 2 / readerH
        let y = (readerW - W) / 2 / readerW

        let width = H / readerH
        let height = W / readerW

        return CGRect(x: x, y: y, width: width, height: height)
    }

    // AVCaptureMetadataOutput的回调
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects.count > 0 {
            session.stopRunning()
            let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            print(metadataObj.stringValue)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
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
        scanNet.layer.add(scanAnim, forKey: "translationAnimation")
    }

    // 各种回调---------------------------------------------------------
    func onBack() {
        let _ = navigationController?.popViewController(animated: true)
    }

    func onOpenAlbum() {
        print("打开相册Album")
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let ctrller = UIImagePickerController()
            ctrller.delegate = self

            ctrller.sourceType = .savedPhotosAlbum

            ctrller.modalTransitionStyle = .flipHorizontal
            present(ctrller, animated: true, completion: nil)
        } else {
            UITools.showAlert(self, title: "提示", msg: "设备不支持访问相册，请在设置->隐私->照片中进行设置！", type: 1, callback: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage//获取图片
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]) //初始化监视器

        picker.dismiss(animated: true) {
            let features = detector?.features(in: CIImage(cgImage: img.cgImage!))
            if (features?.count)! >= 1 {
                let feature: CIQRCodeFeature = features![0] as! CIQRCodeFeature
                let scanResult = feature.messageString

                // 展示结果
                UITools.showAlert(self, title: "结果", msg: scanResult!, type: 1, callback: nil)
            } else {
                UITools.showAlert(self, title: "提示", msg: "图片中并没有二维码", type: 1, callback: nil)
            }
        }
    }

    func onPressFlash(_ btn: UIButton) {
        print("闪光灯")

        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! && (device?.hasFlash)! {
            do {
                try device?.lockForConfiguration()
            } catch {
                return
            }

            btn.isSelected = !btn.isSelected
            let turnOn: Bool = btn.isSelected

            if turnOn == true {
                device?.torchMode = .on
                device?.flashMode = .on
            } else {
                device?.torchMode = .off
                device?.flashMode = .off
            }

            device?.unlockForConfiguration()
        } else {
            UITools.showAlert(self, title: "提示", msg: "并没有闪光灯", type: 1, callback: nil)
        }
    }
    
}
