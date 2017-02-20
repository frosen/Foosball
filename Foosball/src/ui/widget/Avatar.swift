//
//  Avatar.swift
//  Foosball
//
//  Created by luleyan on 16/10/11.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class Avatar: UIImageView {
    class func create(rect: CGRect, name: String, url: String) -> Avatar {
        let avatar = Avatar(frame: rect)
        if name != "" {
            avatar.set(name: name, url: url)
        }
        return avatar
    }

    // 保存头像背景色和名字的img
    static var avatarImgDict: [String: UIImage] = [:]

    func set(name: String, url: String) {
        var avatarImg = Avatar.avatarImgDict[name]

        if avatarImg == nil {
            let viewFrame = CGRect(x: 0, y: 0, width: 70, height: 70)
            let avatarView = UIView(frame: viewFrame)

            // 名字不同底色也不同
            var asciiTab: [Int] = [0, 0, 0]
            var i = 0
            var firstAscii: Int = 0 //取第一个字符的ascii，用于制定文字大小
            for s in name.unicodeScalars {
                if firstAscii == 0 { firstAscii = Int(s.value) }
                asciiTab[i] = asciiTab[i] + Int(s.value) * 5 //名字每个字的int值加和到三个值中 乘以5是让相邻的数得到更大的差异
                i += 1
                if i >= 3 { i = 0 }
            }
            var colorTab: [CGFloat] = [0, 0, 0]
            colorTab[0] = CGFloat(asciiTab[0] % 155 + 100) / 255 // int值处理到 100-255之间并转成0-1的float
            colorTab[1] = CGFloat(asciiTab[1] % 255) / 255 // 0-200
            colorTab[2] = CGFloat(asciiTab[1] % 100) / 255 // 0-100
            let colorT = asciiTab[0] + asciiTab[1] + asciiTab[2] // 通过这个值切换三个值对应的rgb，这样可以让颜色差别更大

            let r: CGFloat = colorTab[(0 + colorT) % 3]
            let g: CGFloat = colorTab[(1 + colorT) % 3]
            let b: CGFloat = colorTab[(2 + colorT) % 3]

            avatarView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)

            // 名字
            let nameLbl = UILabel(frame: viewFrame)
            avatarView.addSubview(nameLbl)

            // 只获取一个字
            let index = name.index(name.startIndex, offsetBy: 1)
            let subString = name.substring(to: index)

            nameLbl.text = subString

            nameLbl.textAlignment = NSTextAlignment.center
            nameLbl.textColor = UIColor.white

            // 根据第一个字是中英文，计算font
            let nameFont: CGFloat = firstAscii < 128 ? 50 : 35
            nameLbl.font = UIFont.boldSystemFont(ofSize: nameFont)

            avatarView.layer.cornerRadius = viewFrame.width / 2 //圆形

            avatarImg = UITools.turnViewToImage(avatarView)
            Avatar.avatarImgDict[name] = avatarImg!
        }

        if url == "" {
            image = avatarImg!

        } else {
            sd_setImage(with: URL(string: url), placeholderImage: avatarImg!)

            // 确保头像一定是圆的，所以不再需要圆角
            // layer.cornerRadius = rect.width / 2 //圆形
            // layer.masksToBounds = true //剪切掉边缘以外
        }
    }
}



