//
//  StateView.swift
//  Foosball
//
//  Created by luleyan on 16/10/1.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class StateView: UIView {

    let rect = CGRect(x: 0, y: 0, width: 30, height: 12)
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
        backgroundColor = UIColor.red
//        layer.cornerRadius = 2
    }

    func setState(_ state: EventState) {
        var string: String = ""
        var bgColor: UIColor = UIColor.red
        switch state {
        case .invite:
            string = "邀请"
            bgColor = UIColor.green
        case .ongoing:
            string = "进行中"
            bgColor = UIColor.orange
        case .confirm:
            string = "接受"
            bgColor = UIColor.purple
        case .refuse:
            string = "拒绝"
            bgColor = UIColor.blue
        case .cash:
            string = "未兑现"
            bgColor = UIColor.red
        case .finish:
            string = "完成"
            bgColor = UIColor.brown
        }

        lbl.text = string
        lbl.sizeToFit()
//        backgroundColor = bgColor
    }
}
