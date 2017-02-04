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
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.accessoryType = .disclosureIndicator
    }
}

class OwnRankCell: BaseCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.accessoryType = .disclosureIndicator
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
