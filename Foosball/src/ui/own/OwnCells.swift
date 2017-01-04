//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnScoreCell: BaseCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.accessoryType = .disclosureIndicator
    }
}

class OwnRankCell: BaseCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.accessoryType = .disclosureIndicator
    }
}

class OwnQRCell: BaseCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 200
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        self.selectionStyle = .none //使选中后没有反应

        //bg
        let qrbgW: CGFloat = 170
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.bounds = CGRect(x: 0, y: 0, width: qrbgW, height: 185)
        bgView.center = CGPoint(x: w / 2, y: 100)
        bgView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)

        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOffset = CGSize(width: 1, height: 1)
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 2

        //标题
        let lbl = UILabel()
        bgView.addSubview(lbl)
        lbl.text = "扫描二维码加我吧"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.sizeToFit()
        lbl.center = CGPoint(x: qrbgW / 2, y: 15)

        // 设置二维码
        let qrimg = QRCodeTools.createQRCode("http://www.baidu.com")
        bgView.addSubview(qrimg)
        qrimg.center = CGPoint(x: qrbgW / 2, y: 103)
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
