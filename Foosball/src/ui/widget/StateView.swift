//
//  StateView.swift
//  Foosball
//
//  Created by luleyan on 16/10/1.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class StateView: UIView {

    private static let h: CGFloat = 16
    private var lbl: UILabel! = nil

    private var small: Bool = false

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(small: Bool = false) {
        let r = CGRect(x: 0, y: 0, width: StateView.h * (small ? 1 : 2), height: StateView.h)
        super.init(frame: r)
        self.small = small

        lbl = UILabel(frame: r)
        addSubview(lbl)

        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 12)
        lbl.textColor = UIColor.white

        layer.cornerRadius = StateView.h / 2
    }

    func setState(_ state: EventState) {
        var string: String
        var bgColor: UIColor

        switch state {
        case .invite:
            string = "邀请"
            bgColor = UIColor(red: 0, green: 0.9, blue: 0.5, alpha: 1)
        case .ready:
            string = "预备"
            bgColor = UIColor.purple
        case .ongoing:
            string = "进行"
            bgColor = UIColor.red
        case .waiting:
            string = "等待"
            bgColor = UIColor.blue
        case .win:
            string = "胜利"
            bgColor = UIColor.orange
        case .lose:
            string = "失败"
            bgColor = UIColor.brown
        case .honoured:
            string = "兑现"
            bgColor = UIColor.orange
        case .finish:
            string = "完成"
            bgColor = UIColor.brown
        case .impeach:
            string = "质疑"
            bgColor = UIColor.purple
        case .keepImpeach_win: fallthrough
        case .keepImpeach_lose:
            string = "存疑"
            bgColor = UIColor.purple
        }

        lbl.text = small ? string.substring(to: string.index(string.startIndex, offsetBy: 1)) : string
        backgroundColor = bgColor
    }
}
