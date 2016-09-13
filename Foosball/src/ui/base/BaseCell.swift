//
//  BaseCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {
    var w: CGFloat = 0
    var h: CGFloat = 0
    required init(id: String?) {
        super.init(style: .Default, reuseIdentifier: id)
        self.accessoryType = .None // 默认
        w = UIScreen.mainScreen().bounds.width
        h = self.dynamicType.getCellHeight() //dynamicType可以获取对象的类，然后就能使用类函数了

        initData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }

    func initData() {}
    func setEvent(e: Event, index: NSIndexPath) {} //需要继承的，把事件设置进去

    //非常方便的创建cell
    struct CInfo {
        var id: String
        var cls: AnyClass
        init(id: String, c: AnyClass) {
            self.id = id
            self.cls = c
        }
    }

    class func create(index: NSIndexPath, tableView: UITableView, e: Event?, getInfoCallback: (NSIndexPath) -> CInfo) -> UITableViewCell {
        let info: CInfo! = getInfoCallback(index)

        let cls = info.cls as! BaseCell.Type

        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(info.id)
        if cell == nil {
            cell = cls.init(id: info.id)
        }

        let baseCell = cell as! BaseCell
        if e != nil {
            baseCell.setEvent(e!, index: index)
        }

        return cell!
    }
}








