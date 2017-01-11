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
            e.location = loc
            self.setData(e, index: nil)
            return true
        }
        createVC.navigationController!.pushViewController(mapVC, animated: true)
    }
}

class CreateStep3WagerHeadCell: DetailHeadCell {
    var curCount: Double = 1.0

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("奖杯")

        let stepper = UIStepper()
        contentView.addSubview(stepper)
        stepper.center = CGPoint(x: w - DetailG.headMargin - stepper.frame.width / 2, y: h / 2)
        stepper.tintColor = BaseColor

        let e = d as! Event
        stepper.value = Double(e.wager.count)
        curCount = Double(e.wager.count)


        stepper.isContinuous = false
        stepper.autorepeat = false
        stepper.addTarget(self, action: #selector(CreateStep3WagerHeadCell.onPressStepper(_:)), for: .touchUpInside)

        stepper.minimumValue = 1.0
        stepper.maximumValue = 9.0

        // 下面的线
        let line = UIView(frame: CGRect(x: 0, y: h - 1, width: w, height: 1))
        contentView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
    }

    func onPressStepper(_ st: UIStepper) {
        if st.value == curCount {
            return
        }

        let createCtrlr = ctrlr as! CreateStep3Ctrlr
        createCtrlr.modifyWagerCount(add: st.value > curCount)
        curCount = st.value
    }
}

class CreateStep3WagerCell: BaseCell, UIPickerViewDelegate, UIPickerViewDataSource {
    private static let pickerHeight: CGFloat = 130
    private static let textHeight: CGFloat = 30

    private var picker: UIPickerView! = nil
    private var curIndex: Int = 0

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return pickerHeight + textHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        picker = UIPickerView(frame: CGRect(x: 30, y: 0, width: w - 60, height: CreateStep3WagerCell.pickerHeight))
        contentView.addSubview(picker)

        picker.delegate = self
        picker.dataSource = self

        // 描述文字或者自定义输入框
        let lbl = UILabel(frame: CGRect(x: 30, y: CreateStep3WagerCell.pickerHeight, width: w - 60, height: CreateStep3WagerCell.textHeight))
        contentView.addSubview(lbl)
        lbl.text = "哈哈哈哈哈"
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.textColor = BaseColor
        lbl.textAlignment = .center

        // 下面的线
        let line = UIView(frame: CGRect(x: 0, y: h - 1, width: w, height: 1))
        contentView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curIndex = e.wager.count - index!.row

        let select = e.wager[curIndex]
        picker.selectRow(select.0, inComponent: 0, animated: false)
        picker.selectRow(select.1, inComponent: 1, animated: false)
        picker.selectRow(select.2, inComponent: 2, animated: false)
        print(curIndex, select)
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
            if WagerList.count <= r0 { // 滑动时，其他组的联动有滞后，不加判断会去获取超过界限的数据而崩溃
                return 0
            }
            return WagerList[r0].1.count
        } else {
            let r0 = pickerView.selectedRow(inComponent: 0)
            let r1 = pickerView.selectedRow(inComponent: 1)
            if WagerList.count <= r0 { // 滑动时，其他组的联动有滞后，不加判断会去获取超过界限的数据而崩溃
                return 0
            }
            let wl1 = WagerList[r0].1
            if wl1.count <= r1 {
                return 0
            }
            return wl1[r1].1.count
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
            if WagerList.count <= r0 { // 滑动时，其他组的联动有滞后，不加判断会去获取超过界限的数据而崩溃
                break
            }
            let wl = WagerList[r0].1
            if wl.count <= row {
                break
            }
            label.text = wl[row].0
        default:
            let r0 = pickerView.selectedRow(inComponent: 0)
            let r1 = pickerView.selectedRow(inComponent: 1)

            if WagerList.count <= r0 { // 滑动时，其他组的联动有滞后，不加判断会去获取超过界限的数据而崩溃
                break
            }
            let wl1 = WagerList[r0].1
            if wl1.count <= r1 {
                break
            }
            let wl2 = wl1[r1].1
            if wl2.count <= row {
                break
            }
            label.text = wl2[row]
        }

        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 多项目联动
        if component == 0 {
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
        } else if component == 1 {
            pickerView.reloadComponent(2)
        }

        // 选择状态发送给控制器
        let c0 = pickerView.selectedRow(inComponent: 0)
        let c1 = pickerView.selectedRow(inComponent: 1)
        let c2 = pickerView.selectedRow(inComponent: 2)
        let createCtrlr = ctrlr as! CreateStep3Ctrlr
        createCtrlr.rootCtrlr.createEvent.wager[curIndex] = (c0, c1, c2)
        print("change wager", curIndex, (c0, c1, c2))
    }
}

class CreateStep3DetailHeadCell: DetailHeadCell {
    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        createHead("自定义规则")

        let switcher = UISwitch()
        contentView.addSubview(switcher)
        switcher.center = CGPoint(x: w - DetailG.headMargin - switcher.frame.width / 2, y: h / 2)
        switcher.tintColor = BaseColor

        let createCtrlr = ctrlr as! CreateStep3Ctrlr
        switcher.isOn = createCtrlr.isEnableInputDetail

        switcher.addTarget(self, action: #selector(CreateStep3DetailHeadCell.onPressSwitcher(_:)), for: .touchUpInside)
    }

    func onPressSwitcher(_ switcher: UISwitch) {
        let createCtrlr = ctrlr as! CreateStep3Ctrlr
        createCtrlr.setDetailInputEnable(switcher.isOn)
    }
}

class CreateStep3DetailCell: StaticCell, UITextViewDelegate {
    private let topMargin: CGFloat = 10
    private var input: UITextView! = nil
    private var placeholder: UITextView! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 200
    }
    
    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        input = UITextView(frame: CGRect(x: DetailG.headMargin, y: topMargin, width: w - DetailG.headMargin * 2, height: h - topMargin * 2))
        addSubview(input)
        input.delegate = self
        input.isScrollEnabled = true
        input.font = UIFont.systemFont(ofSize: 18)
        input.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        placeholder = UITextView(frame: input.frame)
        addSubview(placeholder)
        placeholder.font = input.font!
        placeholder.isEditable = false
        placeholder.isUserInteractionEnabled = false
        placeholder.text = "请输入自定义的活动规则..."
        placeholder.textColor = UIColor.lightGray
        placeholder.backgroundColor = UIColor.clear
    }

    func beginInput() {
        input.becomeFirstResponder()
    }

    func endInput() {
        input.resignFirstResponder()
    }

    func getInputText() -> String {
        return input.text
    }

    // delegate --------------------------

    func textViewDidChange(_ textView: UITextView) {
        // 隐藏holder
        placeholder.isHidden = textView.hasText

        // 记录输入
        let cvc = ctrlr as! CreateStep3Ctrlr
        cvc.rootCtrlr.createEvent.detail = textView.text
    }
}

