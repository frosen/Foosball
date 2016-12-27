//
//  CreateStep3Cell.swift
//  Foosball
//  下面很多的cell样式和detail中的类似
//  Created by 卢乐颜 on 2016/12/11.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class CreateStep3TimeHeadCell: DetailHeadCell {
    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("基本信息")
    }
}

class CreateStep3TimeCell: DetailTimeCell {
    override func setTimePickerAttri(_ tpv: TimePickerView) {
        // pass
    }

    override func onGetTimeFromPicker(_ t: Time, e: Event) -> Bool {
        if t < Time(timeIntervalSinceNow: 900) { // 比当前往后15分钟以内
            UITools.showAlert(self.ctrlr, title: "时间的选择感觉不太好", msg: "请指定的时间在至少15分钟之后吧", type: 1, callback: nil)
            return false
        }

        e.time = t
        self.setData(e, index: nil) // 重置cell UI
        return true
    }
}

class CreateStep3LocationCell: DetailLocationCell {
    override func createMapVC(e: Event) {
        let createVC = (ctrlr as! CreatePageBaseCtrlr).rootCtrlr!
        let mapVC = MapController(rootVC: createVC.rootVC, l: e.location) { loc in
            return true
        }
        createVC.navigationController!.pushViewController(mapVC, animated: true)
    }
}

class CreateStep3WagerHeadCell: DetailHeadCell {
    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("奖杯")
    }
}

class CreateStep3WagerCell: BaseCell, UIPickerViewDelegate, UIPickerViewDataSource {
    private var picker: UIPickerView! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 150
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        picker = UIPickerView(frame: CGRect(x: 15, y: 0, width: w - 30, height: h))
        contentView.addSubview(picker)

        picker.delegate = self
        picker.dataSource = self

        picker.selectRow(1, inComponent: 0, animated: false)
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let createEvent = d as! Event
        Location.getCurLoc() { loc in
            guard let l = loc else {
                return
            }

            createEvent.location = l
            self.detailTextLabel!.text = l.toString
        }
    }

    // UIPickerViewDelegate, UIPickerViewDataSource ------------------------------------

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return WagerList.count
        } else if component == 1 {
            let r0 = pickerView.selectedRow(inComponent: 0)
            return WagerList[r0].1.count
        } else {
            let r0 = pickerView.selectedRow(inComponent: 0)
            let r1 = pickerView.selectedRow(inComponent: 1)
            return (WagerList[r0].1)[r1].1.count
        }
    }

    final public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear

        switch component {
        case 0:
            label.text = WagerList[row].0
        case 1:
            let r0 = pickerView.selectedRow(inComponent: 0)
            label.text = (WagerList[r0].1)[row].0
        default:
            let r0 = pickerView.selectedRow(inComponent: 0)
            let r1 = pickerView.selectedRow(inComponent: 1)
            label.text = ((WagerList[r0].1)[r1].1)[row]
        }

        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            pickerView.reloadComponent(2)
        }
    }
}

class CreateStep3DetailHeadCell: StaticCell {

}

class CreateStep3DetailCell: StaticCell {
    
}

