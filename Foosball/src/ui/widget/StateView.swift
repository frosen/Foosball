//
//  StateView.swift
//  Foosball
//
//  Created by luleyan on 16/10/1.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class StateView: UIView {

    let rect = CGRect(x: 0, y: 0, width: 34, height: 14)
    var lbl: UILabel! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: rect)

        lbl = UILabel(frame: rect)
        addSubview(lbl)

        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 10)
        lbl.textColor = UIColor.white

        layer.cornerRadius = 3
    }

    func setState(_ state: EventState) {
        var string: String = ""
        var bgColor: UIColor = UIColor.red
        switch state {
        case .invite:
            string = "邀 请"
            bgColor = UIColor(red: 0, green: 0.9, blue: 0.5, alpha: 1)
        case .ongoing:
            string = "进行中"
            bgColor = UIColor.orange
        case .confirm:
            string = "接 受"
            bgColor = UIColor.purple
        case .refuse:
            string = "拒 绝"
            bgColor = UIColor.blue
        case .cash:
            string = "未兑现"
            bgColor = UIColor.red
        case .finish:
            string = "完 成"
            bgColor = UIColor.brown
        }

        lbl.text = string
        backgroundColor = bgColor
    }
}
