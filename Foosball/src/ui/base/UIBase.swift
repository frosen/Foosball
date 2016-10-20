//
//  UIBase.swift
//  Foosball
//  UI的基础设置
//  Created by luleyan on 16/9/7.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

let BaseColor: UIColor = UIColor(hue: 16 / 360, saturation: 0.7, brightness: 1.0, alpha: 1.0)
let DarkBaseColor: UIColor = UIColor(hue: 16 / 360, saturation: 0.9, brightness: 0.8, alpha: 1.0)

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
        if type == 1 {
            alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: callback))
        } else {
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: callback))
        }
        target.present(alert, animated: true, completion: nil)
    }
}

