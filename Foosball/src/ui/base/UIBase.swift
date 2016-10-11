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
}

