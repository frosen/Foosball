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
    var delegate: UIViewController! = nil
    required init(id: String, d: Data? = nil, index: IndexPath? = nil) {
        super.init(style: .default, reuseIdentifier: id)
        self.accessoryType = .none // 默认
        w = UIScreen.main.bounds.width
        h = type(of: self).getCellHeight(d, index: index) //dynamicType可以获取对象的类，然后就能使用类函数了
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 44
    }

    func initData(_ d: Data?, index: IndexPath?) {} //需要继承的，把事件设置进去
    func setData(_ d: Data?, index: IndexPath?) {}

    //非常方便的创建cell
    struct CInfo {
        var id: String
        var cls: AnyClass
        init(id: String, c: AnyClass) {
            self.id = id
            self.cls = c
        }
    }

    class func create(_ index: IndexPath, tableView: UITableView, d: Data, delegate: UIViewController,  getInfoCallback: (IndexPath) -> CInfo) -> UITableViewCell {
        let info: CInfo! = getInfoCallback(index)

        let cls = info.cls as! BaseCell.Type

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: info.id)
        if cell == nil {
            cell = cls.init(id: info.id, d: d, index: index)

            let baseCell = cell as! BaseCell
            baseCell.delegate = delegate
            baseCell.initData(d, index: index)
        }

        let baseCell = cell as! BaseCell
        baseCell.setData(d, index: index)

        return cell!
    }
}

extension BaseCell {
    func createDownLine() {
        let downLine = UIView(frame: CGRect(x: 0, y: h - 0.5, width: w, height: 0.5))
        contentView.addSubview(downLine)
        downLine.backgroundColor = LineColor
    }
}









