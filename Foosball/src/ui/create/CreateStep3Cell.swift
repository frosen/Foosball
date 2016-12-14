//
//  CreateStep3Cell.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/12/11.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3TimeCell: StaticCell {

    var createEvent: Event! = nil
    var tpv: TimePickerView? = nil

    override class func new(cls: BaseCell.Type, id: String) -> BaseCell {
        return cls.init(id: id, s: .value1, t: .disclosureIndicator)
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        createEvent = d as! Event
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        textLabel?.text = "时间"
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        detailTextLabel!.text = createEvent.time.toWholeString()
    }

    override func onSelected() {
        if tpv == nil {
            tpv = TimePickerView(date: createEvent.time.time) { date in
                self.createEvent.time = Time(t: date)
                self.setData(nil, index: nil) // 重置cell UI

                // 动画消失
                self.tpv!.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3) {
                    self.tpv!.alpha = 0
                }
            }
            ctrlr.view.addSubview(tpv!)
            tpv!.alpha = 0
        }

        // 动画出现
        self.tpv!.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.tpv!.alpha = 1
        }
    }
}

class CreateStep3MapCell: StaticCell {
    override class func new(cls: BaseCell.Type, id: String) -> BaseCell {
        return cls.init(id: id, s: .value1, t: .disclosureIndicator)
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        textLabel?.text = "地点"
    }
}
