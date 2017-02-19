//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnScoreCell: BaseCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return 120
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        accessoryType = .none
        selectionStyle = .none

        let linesFrame = [
            CGRect(x: 30, y: 60, width: w - 60, height: 0.5),
            CGRect(x: w / 3, y: 15, width: 0.5, height: 30),
            CGRect(x: w / 3 * 2, y: 15, width: 0.5, height: 30),
            CGRect(x: w / 2, y: 75, width: 0.5, height: 30),
        ]

        for lineFrame in linesFrame {
            let line = UIView(frame: lineFrame)
            contentView.addSubview(line)
            line.backgroundColor = UIColor.lightGray
        }
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {

    }
}

class OwnNormalCell: UITableViewCell {
    init(id: String) {
        super.init(style: .value1, reuseIdentifier: id)

        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }

    func setUIData(image img: UIImage, title: String, subTitle: String) {
        imageView!.image = img
        textLabel!.text = title
        detailTextLabel!.text = subTitle
        accessoryType = .disclosureIndicator
    }
}
