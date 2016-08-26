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

        let bytesPerRow = width * 4
        let bytesSize = bytesPerRow * width
        let rgbImageBuf = malloc(bytesSize)

        let cs  = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.NoneSkipLast.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue
        let bitmapRef = CGBitmapContextCreate(rgbImageBuf, width, width, 8, bytesPerRow, cs, bitmapInfo)

        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(outImg, fromRect: extentRect)
        CGContextSetInterpolationQuality(bitmapRef, .None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extentRect, bitmapImage)

        // color
        let components = CGColorGetComponents(color.CGColor)
        let r: UInt8 = UInt8(components[0] * 255)
        let g: UInt8 = UInt8(components[1] * 255)
        let b: UInt8 = UInt8(components[2] * 255)
        let pixelNum = width * width //宽 * 高
        var pCurPtr = UnsafeMutablePointer<UInt32>(rgbImageBuf)

        var line: Int = 1 // 行数
        for i in 0 ..< pixelNum {
            if width * line <= i {
                line += 1
            }

            let ptr = UnsafeMutablePointer<UInt8>(pCurPtr)
            if (pCurPtr.memory & 0xFFFFFF00) < 0x99999900 {
                let rate: Float = 1 - Float(line) / Float(width) //根据行数，设置一个比例，从指定颜色一直降到黑色，实现渐变
                ptr[3] = UInt8(rate * Float(r))
                ptr[2] = UInt8(rate * Float(g))
                ptr[1] = UInt8(rate * Float(b))
            } else {
                ptr[0] = 0
            }
            pCurPtr = pCurPtr.successor()
        }

        let dataProvider = CGDataProviderCreateWithData(nil, rgbImageBuf, bytesSize, nil)
        let imageInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Last.rawValue | CGBitmapInfo.ByteOrder32Little.rawValue)
        let imageRef = CGImageCreate(width, width, 8, 32, bytesPerRow, cs, imageInfo, dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault)

        return UIImage(CGImage: imageRef!)
    }
}
