//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class OwnScoreCell: UITableViewCell {
    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }
}

class OwnRankCell: UITableViewCell {
    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .DisclosureIndicator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }
}

class OwnQRCell: UITableViewCell {
    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = OwnQRCell.getCellHeight()
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        self.selectionStyle = .None //使选中后没有反应

        //标题
        let lbl = UILabel()
        contentView.addSubview(lbl)
        lbl.text = "扫描二维码"
        lbl.font = UIFont.boldSystemFontOfSize(15)
        lbl.sizeToFit()
        lbl.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: 20)

        // 设置二维码
        let qrimg = QRCodeTools.createQRCode("www.baidu.com/www.baidu.com/www.baidu.com/www.baidu.com")
        contentView.addSubview(qrimg)
        qrimg.center = CGPoint(x: UIScreen.mainScreen().bounds.width / 2, y: 110)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 200
    }
}

class OwnNormalCell: UITableViewCell {
    init(reuseIdentifier: String) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)

        textLabel?.font = UIFont.systemFontOfSize(13)
        detailTextLabel?.font = UIFont.systemFontOfSize(13)
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
        accessoryType = .DisclosureIndicator
    }
}
