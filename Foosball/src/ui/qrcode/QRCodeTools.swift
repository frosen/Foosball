//
//  QRCodeTools.swift
//  Foosball
//
//  Created by luleyan on 16/8/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class QRCodeTools: NSObject {
    class func createQRCode(content: String) -> UIImageView {
        let width: Int = 150
        let color: UIColor = UIColor.redColor()

        let outImg = createQRImg(content)

        //设置大小和颜色
        let qrimg = createQRImageView(outImg, width: width, color: color)

        //生成imageView
        let qrview = UIImageView()
        qrview.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        qrview.image = qrimg

        return qrview
    }

    class func createQRImg(content: String) -> CIImage {
        let filter: CIFilter! = CIFilter(name: "CIQRCodeGenerator")
        filter.setDefaults()

        let data = content.dataUsingEncoding(NSUTF8StringEncoding)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") //设置成高容错率

        return filter!.outputImage!
    }

    class func createQRImageView(outImg: CIImage, width: Int, color: UIColor) -> UIImage {
        //size
        let extentRect = CGRectIntegral(outImg.extent)
        let orignW = CGRectGetWidth(extentRect)
        let scale = CGFloat(width) / orignW

        //color
        let components = CGColorGetComponents(color.CGColor)
        let r: CGFloat = components[0] * 255
        let g: CGFloat = components[1] * 255
        let b: CGFloat = components[2] * 255

        let cs  = CGColorSpaceCreateDeviceRGB()
        let bitmapRef = CGBitmapContextCreate(nil, width, width, 8, 0, cs, CGImageAlphaInfo.None.rawValue)

        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(outImg, fromRect: extentRect)
        CGContextSetInterpolationQuality(bitmapRef, .None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extentRect, bitmapImage)

        let scaledImage: CGImage! = CGBitmapContextCreateImage(bitmapRef) // 创建具有内容的位图图像
        return UIImage(CGImage: scaledImage)

        //设置颜色



    }
}
