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
        var color1: UIColor
        var rect: CGRect

        init(c1: UIColor, r: CGRect) {
            self.color1 = c1
            self.rect = r
        }
    }

    var typeBtnAttriList: [TypeBtnAttri] = []

    // 各种控件
    var step: Int = 1
    var stepView: UIView! = nil
    var typeBtns: [UIView] = []

    override func setUI() {
        stepView = UIView(frame: CGRect(x: 0, y: 64, width: pageSize.width, height: pageSize.height - 64))
        view.addSubview(stepView)

        let mg: CGFloat = 4 // 留边
        let designW = stepView.frame.width / 2
        let designH = stepView.frame.height / 2

        typeBtnAttriList.append(TypeBtnAttri(
            c1: UIColor(hue: 3 / 360, saturation: 0.84, brightness: 0.97, alpha: 1.0),
            r: CGRect(x: mg, y: mg, width: designW - mg * 1.5, height: designH - mg * 1.5)
        ))

        typeBtnAttriList.append(TypeBtnAttri(
            c1: UIColor(hue: 343 / 360, saturation: 0.74, brightness: 0.75, alpha: 1.0),
            r: CGRect(x: designW + mg * 0.5, y: mg, width: designW - mg * 1.5, height: designH - mg * 1.5)
        ))

        typeBtnAttriList.append(TypeBtnAttri(
            c1: UIColor(hue: 257 / 360, saturation: 0.57, brightness: 0.49, alpha: 1.0),
            r: CGRect(x: mg, y: designH + mg * 0.5, width: designW - mg * 1.5, height: designH - mg * 1.5)
        ))

        typeBtnAttriList.append(TypeBtnAttri(
            c1: UIColor(hue: 205 / 360, saturation: 0.71, brightness: 0.89, alpha: 1.0),
            r: CGRect(x: designW + mg * 0.5, y: designH + mg * 0.5, width: designW - mg * 1.5, height: designH - mg * 1.5)
        ))

        let typeBtnCount: Int = typeBtnAttriList.count

        for i in 0 ..< typeBtnCount {
            // 按钮属性
            let attri = typeBtnAttriList[i]

            let viewTypeBtn = UIView(frame: attri.rect)
            stepView.addSubview(viewTypeBtn)
            typeBtns.append(viewTypeBtn)

            // 点击事件
            viewTypeBtn.tag = i
            let tap = UITapGestureRecognizer(target: self, action: #selector(CreateCtrlrStep1.tapBtn(ges:)))
            viewTypeBtn.addGestureRecognizer(tap)

            // 添加渐变色背景
            let graLr = CAGradientLayer()
            graLr.colors = [attri.color1.cgColor, UIColor.blue.cgColor]
            graLr.startPoint = CGPoint(x: 0, y: 0)
            graLr.endPoint = CGPoint(x: 0, y: 1)
            graLr.frame = CGRect(x: 0, y: 0, width: attri.rect.width, height: attri.rect.height)
            viewTypeBtn.layer.addSublayer(graLr)

            // 图标

            // 标题

            // 描述
        }
    }

    // step -------------------------
    func tapBtn(ges: UITapGestureRecognizer) {
        let index = ges.view!.tag
        print("step 1 select: ", index)

        let e = Event(ID: DataID(ID: 0))
        e.type = EventType(rawValue: index)!
        rootCtrlr.createEvent = e

        rootCtrlr.movePage(gotoRight: true)
    }
}








