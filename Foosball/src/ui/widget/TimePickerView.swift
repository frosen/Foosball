//
//  TimePickerView.swift
//  Foosball
//
//  Created by luleyan on 2016/12/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class TimePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    private let tableWidth: CGFloat = 42
    private let tableHeight: CGFloat = 33
    private let rowNum: Int = 7 //行数
    private let colNum: Int = 7 //列数
    private let headHeight: CGFloat = 35
    private let pickerHeight: CGFloat = 100
    private let tailHeight: CGFloat = 40

    private var title: UILabel! = nil
    private var calendarView: UIView! = nil

    private var confirmCallback: ((Date) -> Void)! = nil

    // 展示的年月
    private var onShowYear: Int = 0
    private var onShowMonth: Int = 0

    // 被选中的日期
    private var sYear: Int = 0
    private var sMonth: Int = 0
    private var sDay: Int = 0
    private var sHour: Int = 0
    private var sMinute: Int = 0

    private weak var curSelectedDayView: UILabel? = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(date: Date, callback: @escaping ((Date) -> Void)) {
        let ww = UIScreen.main.bounds.width
        let wh = UIScreen.main.bounds.height
        super.init(frame: CGRect(x: 0, y: 0, width: ww, height: wh))

        confirmCallback = callback

        let calendar = Calendar.current
        let dateCom = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        sYear = dateCom.year!
        sMonth = dateCom.month!
        sDay = dateCom.day!
        sHour = dateCom.hour!
        sMinute = dateCom.minute!

        onShowYear = sYear
        onShowMonth = sMonth

        initUI()
        showDateView()
    }

    private func initUI() {
        // 背景色
        let bgV = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addSubview(bgV)
        bgV.alpha = 0.3
        bgV.backgroundColor = UIColor.black

        // 内容区域
        let contentBGView = UIView()
        addSubview(contentBGView)
        contentBGView.bounds = CGRect(
            x: 0, y: 0,
            width: tableWidth * CGFloat(colNum),
            height: headHeight + tableHeight * CGFloat(rowNum) + pickerHeight + tailHeight
        )
        contentBGView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        contentBGView.backgroundColor = UIColor.white

        // 翻月箭头
        let arrowEdge: CGFloat = 30
        let left = UIImageView(image: UIImage(named: "arrows_right"))
        contentBGView.addSubview(left)
        left.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        left.center = CGPoint(x: arrowEdge, y: headHeight / 2)

        let right = UIImageView(image: UIImage(named: "arrows_right"))
        contentBGView.addSubview(right)
        right.center = CGPoint(x: contentBGView.frame.width - arrowEdge, y: headHeight / 2)

        // 标题
        title = UILabel(frame: CGRect(x: 0, y: 0, width: contentBGView.frame.width, height: headHeight))
        contentBGView.addSubview(title)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .center

        // 标题占了整个head，所以靠点击标题，并查看在左还是在右出发翻月份，而不是箭头
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(TimePickerView.tapToTurnMonth(ges:)))
        title.isUserInteractionEnabled = true
        title.addGestureRecognizer(titleTap)

        // 日历区间
        let calendarBGView = UIView(frame: CGRect(x: 0, y: headHeight, width: contentBGView.frame.width, height: tableHeight * CGFloat(rowNum)))
        contentBGView.addSubview(calendarBGView)
        calendarBGView.backgroundColor = UIColor(white: 0.93, alpha: 1.0)

        let weekStrs = ["日", "一", "二", "三", "四", "五", "六"];
        for i in 0 ..< weekStrs.count {
            let lab = UILabel(frame: CGRect(x: CGFloat(i) * tableWidth, y: 0, width: tableWidth, height: tableHeight))
            calendarBGView.addSubview(lab)
            lab.textColor = UIColor(white: 0.52, alpha: 1.0)
            lab.textAlignment = .center
            lab.font = UIFont.systemFont(ofSize: 10)
            lab.text = weekStrs[i]
        }

        calendarView = UIView(frame: CGRect(
            x: 0, y: headHeight + tableHeight,
            width: contentBGView.frame.width,
            height: tableHeight * (CGFloat(rowNum) - 1)))
        contentBGView.addSubview(calendarView)

        // 时间选则
        let timePicker = UIPickerView(frame: CGRect(
            x: contentBGView.frame.width * 0.25,
            y: contentBGView.frame.height - tailHeight - pickerHeight,
            width: contentBGView.frame.width * 0.5,
            height: pickerHeight
        ))
        contentBGView.addSubview(timePicker)
        timePicker.delegate = self
        timePicker.dataSource = self

        // 初始位置，10 * 24 是为了循环滚动设置的，-1是把值和row匹配
        print(sHour, sMinute)
        timePicker.selectRow(10 * 24 + sHour - 1, inComponent: 0, animated: false)
        timePicker.selectRow(10 * 60 + sMinute - 1, inComponent: 1, animated: false)

        // 中间的冒号
        let colon = UILabel()
        contentBGView.addSubview(colon)
        colon.textAlignment = .center
        colon.textColor = UIColor.black
        colon.font = UIFont.boldSystemFont(ofSize: 18)
        colon.text = ""
        colon.sizeToFit()
        colon.center = CGPoint(
            x: contentBGView.frame.width * 0.5,
            y: contentBGView.frame.height - tailHeight - pickerHeight / 2
        )

        // 下方按钮
        let confirmBtn = UIButton(type: .custom)
        contentBGView.addSubview(confirmBtn)

        confirmBtn.bounds = CGRect(x: 0, y: 0, width: 108, height: 28)
        confirmBtn.center = CGPoint(x: contentBGView.frame.width / 2, y: contentBGView.frame.height - tailHeight / 2)

        confirmBtn.setTitle("确  定", for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)

        confirmBtn.backgroundColor = BaseColor
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.layer.masksToBounds = true

        confirmBtn.addTarget(self, action: #selector(TimePickerView.onConfirm), for: .touchUpInside)
    }

    func showDateView() {
        // 标题
        title.text = String(onShowYear) + "年" + String(onShowMonth) + "月"

        // 移除原有的控件
        for item in calendarView.subviews {
            item.removeFromSuperview()
        }

        // 获取本月第一天是星期几
        let dateCom: DateComponents = DateComponents(year: onShowYear, month: onShowMonth, day: 1)
        let calendar = Calendar.current
        let date1 = calendar.date(from: dateCom)!
        let date1Week = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: date1)! - 1

        let nowCom = calendar.dateComponents([.year, .month, .day], from: Time.now.time)

        var w: CGFloat = 0
        var h: CGFloat = 0
        for i in 0 ..< colNum * (rowNum - 1) { // -1 是减去显示星期的一行
            if i == 0 {
                // pass
            } else if i % colNum == 0 {
                h += tableHeight
                w = 0
            } else {
                w += tableWidth
            }

            let dayView = UILabel(frame: CGRect(x: w, y: h, width: tableWidth, height: tableHeight))
            calendarView.addSubview(dayView)
            dayView.font = UIFont.systemFont(ofSize: 10)
            dayView.textAlignment = .center

            let dayDate = date1.addingTimeInterval(TimeInterval(i - date1Week) * 24 * 3600)

            let dayCom = calendar.dateComponents([.year, .month, .day], from: dayDate)
            let dayIndex = dayCom.day!

            if dayCom.year! == nowCom.year! && dayCom.month! == nowCom.month! && dayCom.day! == nowCom.day! {
                dayView.text = "今天"
                dayView.layer.borderColor = BaseColor.cgColor
                dayView.layer.borderWidth = 1
            } else {
                dayView.text = String(dayIndex)
            }

            // 今天以前禁用
            if dayCom.year! * 10000 + dayCom.month! * 100 + dayCom.day! < nowCom.year! * 10000 + nowCom.month! * 100 + nowCom.day! {
                dayView.textColor = UIColor(white: 0.75, alpha: 1.0)
            } else {
                let isSelectedDay = (dayCom.year! == sYear && dayCom.month! == sMonth && dayCom.day! == sDay)
                setDayViewUI(dayView, checked: isSelectedDay)

                dayView.isUserInteractionEnabled = true
                let dayTap = UITapGestureRecognizer(target: self, action: #selector(TimePickerView.tapToTurnDay(ges:)))
                dayView.addGestureRecognizer(dayTap)
                dayView.tag = dayIndex
            }

            // 1号下面加月份
            if dayIndex == 1 {
                let monthLabH: CGFloat = 7
                let monthLab = UILabel(frame: CGRect(x: 0, y: tableHeight - monthLabH, width: tableWidth, height: monthLabH))
                dayView.addSubview(monthLab)
                monthLab.textAlignment = .center
                monthLab.font = UIFont.systemFont(ofSize: 7)
                monthLab.textColor = dayView.textColor
                monthLab.text = String(dayCom.month!) + "月"
                monthLab.tag = 109 // 为了变色时候查找方便
            }
        }

    }

    func tapToTurnMonth(ges: UITapGestureRecognizer) {
        let pos = ges.location(in: title)
        let titleWidth = title.frame.width
        let leftDir: Bool
        if pos.x <= titleWidth / 3 {
            leftDir = true
        } else if titleWidth / 3 * 2 <= pos.x {
            leftDir = false
        } else {
            return
        }

        print("tapToTurnMonth", leftDir)

        onShowMonth += leftDir ? -1 : 1
        if onShowMonth > 12 {
            onShowMonth = 1
            onShowYear += 1
        } else if onShowMonth < 1 {
            onShowMonth = 12
            onShowYear -= 1
        }

        showDateView()
    }

    func tapToTurnDay(ges: UITapGestureRecognizer) {
        let dayView = ges.view! as! UILabel
        onSelect(dayView: dayView)
    }

    func onSelect(dayView: UILabel) {
        let day = dayView.tag
        print("onSelect", day)

        setDayViewUI(dayView, checked: true)
        sYear = onShowYear
        sMonth = onShowMonth
        sDay = day
    }

    private func setDayViewUI(_ l: UILabel, checked: Bool) {
        if checked {
            l.textColor = UIColor.white
            l.backgroundColor = BaseColor

            if let curDate = curSelectedDayView {
                setDayViewUI(curDate, checked: false)
            }
            curSelectedDayView = l
        } else {
            l.textColor = UIColor(white: 0.17, alpha: 1.0)
            l.backgroundColor = UIColor.clear
        }

        let monthLab = l.viewWithTag(109) as! UILabel?
        monthLab?.textColor = l.textColor
    }

    func onConfirm() {
        let selectedCom = DateComponents(year: sYear, month: sMonth, day: sDay)
        confirmCallback(selectedCom.date!)
    }

    // UIPickerViewDelegate, UIPickerViewDataSource ------------------------------------
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 24 * 20 // 小时 *10为了循环滚动
        } else {
            return 60 * 20// 分钟
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("did s", row, component)
    }

    final public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear

        let timeNum = (row + 1) % (component == 0 ? 24 : 60)
        if timeNum >= 10 {
            label.text = String(timeNum)
        } else {
            label.text = "0" + String(timeNum)
        }

        return label
    }
}









