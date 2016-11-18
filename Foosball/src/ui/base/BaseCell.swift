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
    var ctrlr: UIViewController! = nil
    required init(id: String, d: BaseData? = nil, index: IndexPath? = nil) {
        super.init(style: .default, reuseIdentifier: id)
        self.accessoryType = .none // 默认
        self.w = UIScreen.main.bounds.width
        self.h = type(of: self).getCellHeight(d, index: index) //dynamicType可以获取对象的类，然后就能使用类函数了
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    func initData(_ d: BaseData?, index: IndexPath?) {} //需要继承的，把事件设置进去
    func setData(_ d: BaseData?, index: IndexPath?) {}

    //非常方便的创建cell
    struct CInfo {
        var id: String
        var cls: AnyClass
        init(id: String, c: AnyClass) {
            self.id = id
            self.cls = c
        }
    }

    // 利用swift的动态语言机制，根据配置表创建cell
    class func create(_ index: IndexPath, tableView: UITableView, d: BaseData, ctrlr: UIViewController,  getInfoCallback: (IndexPath) -> CInfo) -> UITableViewCell {
        let info: CInfo! = getInfoCallback(index)

        let cls = info.cls as! BaseCell.Type

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: info.id)
        if cell == nil {
            cell = cls.init(id: info.id, d: d, index: index)

            let baseCell = cell as! BaseCell
            baseCell.ctrlr = ctrlr
            baseCell.initData(d, index: index)
        }

        let baseCell = cell as! BaseCell
        baseCell.setData(d, index: index)

        return cell!
    }
}

// 静态cell，不会进行重用，如果要重置，要通过reset方法
class StaticCell: BaseCell {
    override class func create(_ index: IndexPath, tableView: UITableView, d: BaseData, ctrlr: UIViewController,  getInfoCallback: (IndexPath) -> CInfo) -> UITableViewCell {
        let info: CInfo! = getInfoCallback(index)

        if !(info.cls is StaticCell.Type) { //如果不是静态cell，还是用basecell的创建
            return BaseCell.create(index, tableView: tableView, d: d, ctrlr: ctrlr, getInfoCallback: getInfoCallback)
        }

        let cls = info.cls as! StaticCell.Type
        var cell: UITableViewCell? = tableView.cellForRow(at: index)
        if cell == nil {
            cell = cls.init(id: info.id, d: d, index: index)

            let staticCell = cell as! StaticCell
            staticCell.ctrlr = ctrlr
            staticCell.initData(d, index: index)
            staticCell.setData(d, index: index)
        }
        
        return cell!
    }

    func resetData(_ d: BaseData?, index: IndexPath?) {
        setData(d, index: index) //如果不继承，则使用set作为reset
    }
}


