//
//  BaseCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol BaseCellDelegate {
    func getCInfo(_ indexPath: IndexPath) -> BaseCell.CInfo
}

class BaseCell: UITableViewCell {
    var w: CGFloat = 0
    var h: CGFloat = 0
    var ctrlr: UIViewController! = nil

    required init(id: String, s: UITableViewCellStyle, t: UITableViewCellAccessoryType) {
        super.init(style: s, reuseIdentifier: id)
        self.accessoryType = t // 默认
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    func initData(_ d: BaseData?, index: IndexPath?) {} //需要继承的，把事件设置进去
    func setData(_ d: BaseData?, index: IndexPath?) {}
    func onSelected(_ d: BaseData? = nil) {}

    //非常方便的创建cell
    struct CInfo {
        var id: String
        var cls: AnyClass
        init(id: String, c: AnyClass) {
            self.id = id
            self.cls = c
        }
    }

    class func new(cls: BaseCell.Type, id: String) -> BaseCell {
        return cls.init(id: id, s: .default, t: .none)
    }

    // 利用swift的动态语言机制，根据配置表创建cell
    class func create(_ index: IndexPath, tableView: UITableView, d: BaseData, ctrlr: UIViewController, delegate: BaseCellDelegate) -> UITableViewCell {
        let info: CInfo! = delegate.getCInfo(index)

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: info.id)
        if cell == nil {
            let cls = info.cls as! BaseCell.Type
            cell = cls.new(cls: cls, id: info.id)

            let baseCell = cell as! BaseCell
            baseCell.w = UIScreen.main.bounds.width
            baseCell.h = type(of: baseCell).getCellHeight(d, index: index) //dynamicType可以获取对象的类，然后就能使用类函数了
            baseCell.ctrlr = ctrlr
            baseCell.initData(d, index: index)
        }

        let baseCell = cell as! BaseCell
        baseCell.setData(d, index: index)

        return cell!
    }
}

protocol StaticCellDelegate: BaseCellDelegate {
    func getIfUpdate(_ indexPath: IndexPath) -> Bool
}

// 静态cell，不会进行重用，如果要重置，要通过reset方法
class StaticCell: BaseCell {
    class func create(_ index: IndexPath, tableView: UITableView, d: BaseData, ctrlr: UIViewController, delegate: StaticCellDelegate) -> UITableViewCell {
        let info: CInfo! = delegate.getCInfo(index)

        if !(info.cls is StaticCell.Type) { //如果不是静态cell，还是用basecell的创建
            return BaseCell.create(index, tableView: tableView, d: d, ctrlr: ctrlr, delegate: delegate)
        }

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: info.id)
        if cell == nil {
            let cls = info.cls as! StaticCell.Type
            cell = cls.new(cls: cls, id: info.id)

            let staticCell = cell as! StaticCell
            staticCell.w = UIScreen.main.bounds.width
            staticCell.h = type(of: staticCell).getCellHeight(d, index: index) //dynamicType可以获取对象的类，然后就能使用类函数了
            staticCell.ctrlr = ctrlr
            staticCell.initData(d, index: index)
            staticCell.setData(d, index: index)
        } else if delegate.getIfUpdate(index) == true {
            let staticCell = cell as! StaticCell
            staticCell.setData(d, index: index)
        }
        
        return cell!
    }

    func resetData(_ d: BaseData?, index: IndexPath?) {
        setData(d, index: index) //如果不继承，则使用set作为reset
    }
}


