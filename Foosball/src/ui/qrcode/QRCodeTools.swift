//
//  QRCodeTools.swift
//  Foosball
//
//  Created by luleyan on 16/8/26.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class QRCodeTools: NSObject {
    class func createQRCode(_ content: String) -> UIImageView {
        let width: Int = 150
        let color: UIColor = UIColor.red

        let outImg = createQRImg(content)

        //设置大小和颜色
        let qrimg = setupQRImg(outImg, width: width, color: color)

        //生成imageView
        let qrview = UIImageView()
        qrview.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        qrview.image = qrimg

        return qrview
    }

    class func createQRImg(_ content: String) -> CIImage {
        let filter: CIFilter! = CIFilter(name: "CIQRCodeGenerator")
        filter.setDefaults()

        let data = content.data(using: String.Encoding.utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") //设置成高容错率

        return filter!.outputImage!
    }

    class func setupQRImg(_ outImg: CIImage, width: Int, color: UIColor) -> UIImage {
        //size
        let extentRect = outImg.extent.integral
        let orignW = extentRect.width
        let scale = CGFloat(width) / orignW

        let bytesPerRow = width * 4
        let bytesSize = bytesPerRow * width
        let rgbImageBuf: UnsafeMutableRawPointer! = malloc(bytesSize)

        let cs  = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        let bitmapRef = CGContext(data: rgbImageBuf, width: width, height: width, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: cs, bitmapInfo: bitmapInfo)

        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(outImg, from: extentRect)
        bitmapRef!.interpolationQuality = .none
        bitmapRef?.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage!, in: extentRect)

        // color
        let components = color.cgColor.components
        let r: UInt8 = UInt8(components![0] * 255)
        let g: UInt8 = UInt8(components![1] * 255)
        let b: UInt8 = UInt8(components![2] * 255)
        let pixelNum = width * width //宽 * 高
        var pCurPtr: UnsafeMutablePointer<UInt32> = rgbImageBuf.assumingMemoryBound(to: UInt32.self)

        var line: Int = 1 // 行数
        for i in 0 ..< pixelNum {
            if width * line <= i {
                line += 1
            }

            let ptr: UnsafeMutablePointer<UInt8> = rgbImageBuf.assumingMemoryBound(to: UInt8.self)
            if (pCurPtr.pointee & 0xFFFFFF00) < 0x99999900 {
                let rate: Float = 1 - Float(line) / Float(width) //根据行数，设置一个比例，从指定颜色一直降到黑色，实现渐变
                ptr[3] = UInt8(rate * Float(r))
                ptr[2] = UInt8(rate * Float(g))
                ptr[1] = UInt8(rate * Float(b))
            } else {
                ptr[0] = 0
            }
            pCurPtr = pCurPtr.successor()
        }

        let dataProvider = CGDataProvider(dataInfo: nil, data: rgbImageBuf!, size: bytesSize) {_,_,_ in }
        let imageInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        let imageRef = CGImage(width: width, height: width, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: bytesPerRow, space: cs, bitmapInfo: imageInfo, provider: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)

        return UIImage(cgImage: imageRef!)
    }
}
