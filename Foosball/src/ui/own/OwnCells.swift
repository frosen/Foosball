//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnScoreCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil) -> CGFloat {
        return 44
    }

    override func initUI() {
        self.accessoryType = .disclosureIndicator
    }
}

class OwnRankCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil) -> CGFloat {
        return 44
    }

    override func initUI() {
        self.accessoryType = .disclosureIndicator
    }
}

class OwnQRCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil) -> CGFloat {
        return 200
    }

    override func initUI() {
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        self.selectionStyle = .none //使选中后没有反应

        //bg
        let bgView = UIView()
        contentView.addSubview(bgView)
        bgView.bounds = CGRect(x: 0, y: 0, width: 170, height: 185)
        bgView.center = CGPoint(x: w / 2, y: 100)
        bgView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)

        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOffset = CGSize(width: 2, height: 1)
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 2

        //标题
        let lbl = UILabel()
        contentView.addSubview(lbl)
        lbl.text = "扫描二维码加我吧"
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        lbl.sizeToFit()
        lbl.center = CGPoint(x: w / 2, y: 20)

        // 设置二维码
        let qrimg = QRCodeTools.createQRCode("www.baidu.com/www.baidu.com/www.baidu.com/www.baidu.com")
        contentView.addSubview(qrimg)
        qrimg.center = CGPoint(x: w / 2, y: 110)
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

    func setUIData(image imgName: String, title: String, subTitle: String) {
        imageView!.image = UIImage(named: imgName)
        textLabel!.text = title
        detailTextLabel!.text = subTitle
        accessoryType = .disclosureIndicator
    }
}
