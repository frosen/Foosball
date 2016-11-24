//
//  CreateCtrlrStep1.swift
//  Foosball
//
//  Created by luleyan on 2016/11/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateCtrlrStep1: CreatePageBaseCtrlr {

    // 类型按钮的属性结构和列表
    struct TypeBtnAttri {
        var color: UIColor

        init(c: UIColor) {
            self.color = c
        }
    }

    let typeBtnAttriList: [TypeBtnAttri] = [
        TypeBtnAttri(c: UIColor(hue: 3 / 360, saturation: 0.84, brightness: 0.97, alpha: 1.0)),
        TypeBtnAttri(c: UIColor(hue: 343 / 360, saturation: 0.74, brightness: 0.75, alpha: 1.0)),
        TypeBtnAttri(c: UIColor(hue: 257 / 360, saturation: 0.57, brightness: 0.49, alpha: 1.0)),
        TypeBtnAttri(c: UIColor(hue: 205 / 360, saturation: 0.71, brightness: 0.89, alpha: 1.0)),
    ]

    // 各种控件
    var typeBtns: [UIView] = [] // 类型按钮

    override func setUI() {

        // 步骤1
        let typeBtnCount: Int = typeBtnAttriList.count
        let typeBtnHeight: CGFloat = pageSize.height / CGFloat(typeBtnCount)

        for i in 0 ..< typeBtnCount {
            // 计算位置
            let pos = typeBtnCount - i - 1
            let btnY = CGFloat(pos) * typeBtnHeight
            let viewTypeBtn = UIView(frame: CGRect(x: 0, y: btnY, width: pageSize.width, height: typeBtnHeight))
            view.addSubview(viewTypeBtn)
            typeBtns.append(viewTypeBtn)

            // 点击事件
            viewTypeBtn.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(CreateCtrlrStep1.tapBtn(ges:)))
            viewTypeBtn.addGestureRecognizer(tap)

            // 按钮属性
            let attri = typeBtnAttriList[pos]

            // 底色 为了以后的晃动效果，底色比view要大
            let cRect = CGRect(
                x: 0, y: -typeBtnHeight,
                width: viewTypeBtn.frame.width,
                // 除了最下面的一个btn，其他btn的color要和本身下边对其，所以是1倍的btnHeight，否则会遮挡下面的btn，而最下一个要2倍是防止晃动时露边
                height: viewTypeBtn.frame.height + (typeBtnHeight * (i == 0 ? 2 : 1))
            )
            let colorView = UIView(frame: cRect)
            viewTypeBtn.addSubview(colorView)
            colorView.backgroundColor = attri.color
        }
    }

    func tapBtn(ges: UITapGestureRecognizer) {

    }
}








