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
