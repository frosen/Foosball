//
//  UIBase.swift
//  Foosball
//  UI的基础设置
//  Created by luleyan on 16/9/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

let LineColor: UIColor = UIColor(white: 0.92, alpha: 1)
let TitleColor: UIColor = UIColor.black
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

    class func createAvatar(_ rect: CGRect, content: String, isURL: Bool) -> UIView {
        let avatarBG = UIView(frame: rect)

        if isURL == true {
            let avatar = UIImageView(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            avatarBG.addSubview(avatar)

            let url = URL(string: content)
            avatar.sd_setImage(with: url)

            avatar.layer.cornerRadius = rect.width / 2 //圆形
            avatar.layer.masksToBounds = true //剪切掉边缘以外

            avatarBG.backgroundColor = UIColor.gray //随便给一种颜色，不给不能形成形状
        } else { //不是url就是名字
            let nameLbl = UILabel(frame: CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
            avatarBG.addSubview(nameLbl)

            // 只获取最多四个字
            let nameCount = content.characters.count
            var nameFont: CGFloat = 0
            if nameCount >= 3 {
                let index = content.index(content.startIndex, offsetBy: 3)
                nameLbl.text = content.substring(to: index)
                nameFont = 19
            } else {
                nameLbl.text = content
                nameFont = (nameCount == 2) ? 25 : 35
            }

            nameLbl.textAlignment = NSTextAlignment.center
            let rate: CGFloat = rect.width / 70
            nameLbl.font = UIFont.boldSystemFont(ofSize: nameFont * rate)
            nameLbl.textColor = UIColor.white

            // 名字不同底色也不同
            var asciiTab: [Int] = [0, 0, 0]
            var i = 0
            for s in content.unicodeScalars {
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
        }
        
        avatarBG.layer.cornerRadius = rect.width / 2 //圆形
        
        return avatarBG
    }
    
}

