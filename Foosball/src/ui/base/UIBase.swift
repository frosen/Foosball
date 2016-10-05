//
//  UIBase.swift
//  Foosball
//  UI的基础设置
//  Created by luleyan on 16/9/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

let LineColor: UIColor = UIColor(white: 0.92, alpha: 1)
let TitleColor: UIColor = UIColor.black
let SubTitleColor: UIColor = UIColor(white: 0.5, alpha: 1)
let TextColor: UIColor = UIColor(white: 0.25, alpha: 1)

let TitleFont: UIFont = UIFont.boldSystemFont(ofSize: 15)
let TextFont: UIFont = UIFont.systemFont(ofSize: 13)

class UITools {
    class func createBarBtnItem(_ target: AnyObject, action: Selector, image img: String) -> UIBarButtonItem {
        let btn = UIButton(type: .custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: img), for: UIControlState())
        let bSize = btn.currentBackgroundImage!.size
        btn.bounds = CGRect(x: 0, y: 0, width: bSize.width, height: bSize.height)
        return UIBarButtonItem(customView: btn)
    }

    class func showAlert(_ target: UIViewController, title: String, msg: String, type: Int, callback: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: callback))
        if type == 2 {
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        }
        target.present(alert, animated: true, completion: nil)
    }

    class func createAvatar(_ rect: CGRect, name: String, url: String) -> UIView {
        let avatarBG = UIView(frame: rect)

        let nameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        avatarBG.addSubview(nameLbl)

        // 只获取一个字
        let index = name.index(name.startIndex, offsetBy: 1)
        let subString = name.substring(to: index)
        nameLbl.text = subString

        nameLbl.textAlignment = NSTextAlignment.center
        nameLbl.textColor = UIColor.white

        // 名字不同底色也不同
        var asciiTab: [Int] = [0, 0, 0]
        var i = 0
        var firstAscii: Int = 0 //取第一个字符的ascii，用于制定文字大小
        for s in name.unicodeScalars {
            if firstAscii == 0 { firstAscii = Int(s.value) }
            asciiTab[i] = asciiTab[i] + Int(s.value) //名字每个字的int值加和到三个值中
            i += 1
            if i >= 3 { i = 0 }
        }
        var colorTab: [CGFloat] = [0, 0, 0]
        for j in 0...2 {
            colorTab[j] = CGFloat(asciiTab[j] % 155 + 100) / 255 // 三个int值处理到 100-255之间并转成0-1的float
        }
        colorTab[2] = 1 - colorTab[2] // 第三个值取反色，为了色彩度更高
        let colorT = asciiTab[0] + asciiTab[1] + asciiTab[2] // 通过这个值切换三个值对应的rgb，这样可以让颜色差别更大

        let r: CGFloat = colorTab[(0 + colorT) % 3]
        let g: CGFloat = colorTab[(1 + colorT) % 3]
        let b: CGFloat = colorTab[(2 + colorT) % 3]

        avatarBG.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)

        // 根据第一个字是中英文，计算font
        let rate: CGFloat = rect.width / 70
        let nameFont: CGFloat = firstAscii < 128 ? 50 : 35
        nameLbl.font = UIFont.boldSystemFont(ofSize: nameFont * rate)

        if url != "" {
            let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            avatarBG.addSubview(avatar)

            avatar.sd_setImage(with: URL(string: url))

            avatar.layer.cornerRadius = rect.width / 2 //圆形
            avatar.layer.masksToBounds = true //剪切掉边缘以外

        }
        
        avatarBG.layer.cornerRadius = rect.width / 2 //圆形
        
        return avatarBG
    }
}

