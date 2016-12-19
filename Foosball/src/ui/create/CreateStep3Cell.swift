//
//  CreateStep3Cell.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/12/11.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3TimeCell: StaticCell {

    private var tpv: TimePickerView? = nil

    override class func new(cls: BaseCell.Type, id: String) -> BaseCell {
        return cls.init(id: id, s: .value1, t: .disclosureIndicator)
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        textLabel?.text = "时间"
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let createEvent = d as! Event
        detailTextLabel!.text = createEvent.time.toWholeString
    }

    override func onSelected(_ d: BaseData? = nil) {
        if tpv == nil {
            let createEvent = d as! Event
            tpv = TimePickerView(date: createEvent.time.time, parents: ctrlr.view) { date in

                if date < Date(timeIntervalSinceNow: 900) { // 比当前往后15分钟以内
                    UITools.showAlert(self.ctrlr, title: "时间的选择感觉不太好", msg: "请指定的时间在至少15分钟之后吧", type: 1, callback: nil)
                    return
                }

                createEvent.time = Time(t: date)
                self.setData(createEvent, index: nil) // 重置cell UI

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

class CreateStep3LocationCell: StaticCell {
    override class func new(cls: BaseCell.Type, id: String) -> BaseCell {
        return cls.init(id: id, s: .value1, t: .disclosureIndicator)
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
        textLabel?.text = "地点"
    }

    override func onSelected(_ d: BaseData? = nil) {
        let createEvent = d as! Event
        let createVC = (ctrlr as! CreatePageBaseCtrlr).rootCtrlr!
        let mapVC = MapController(rootVC: createVC.rootVC, l: createEvent.location)
        createVC.navigationController!.pushViewController(mapVC, animated: true)
    }
}

class CreateStep3WagerHeadCell: StaticCell {

}

class CreateStep3WagerCell: StaticCell {

}

class CreateStep3DetailHeadCell: StaticCell {

}

class CreateStep3DetailCell: StaticCell {
    
}

