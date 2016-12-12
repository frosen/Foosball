//
//  TimePickerView.swift
//  Foosball
//
//  Created by luleyan on 2016/12/12.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class TimePickerView: UIView {
    private let tableWidth: CGFloat = 35
    private let tableHeight: CGFloat = 35 * 0.8
    private let rowNum: Int = 7 //行数
    private let colNum: Int = 7 //列数
    private let headHeight: CGFloat = 35
    private let tailHeight: CGFloat = 40

    private var contentBGView: UIView! = nil
    private var title: UILabel! = nil
    private var calendarView: UIView! = nil

    private var currentMonthDateArray: [Double] = []
    private var year: Int = 0
    private var month: Int = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        let ww = UIScreen.main.bounds.width
        let wh = UIScreen.main.bounds.height
        super.init(frame: CGRect(x: 0, y: 0, width: ww, height: wh))

        let calendar = Calendar.current
        let dateCom = calendar.dateComponents([.year, .month, .day], from: Time.now.time)
        year = dateCom.year!
        month = dateCom.month!

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
        contentBGView = UIView()
        addSubview(contentBGView)
        contentBGView.bounds = CGRect(x: 0, y: 0, width: tableWidth * CGFloat(colNum), height: headHeight + tableHeight * CGFloat(rowNum) + tailHeight)
        contentBGView.center = CGPoint(x: frame.width / 2, y: frame.height / 2)

        contentBGView.layer.cornerRadius = 2.0
        contentBGView.layer.masksToBounds = true

        // 翻月箭头
        let arrowEdge: CGFloat = 30
        let left = UIImageView(image: UIImage(named: "arrows_right"))
        contentBGView.addSubview(left)
        left.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        left.center = CGPoint(x: arrowEdge, y: headHeight / 2)

        let right = UIImageView(image: UIImage(named: "arrows_right"))
        contentBGView.addSubview(right)
        right.center = CGPoint(x: frame.width - arrowEdge, y: headHeight / 2)

        // 标题
        title = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: headHeight))
        contentBGView.addSubview(title)
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 14)
        title.textAlignment = .center

        // 标题占了整个head，所以靠点击标题，并查看在左还是在右出发翻月份，而不是箭头
        let titleTap = UITapGestureRecognizer(target: self, action: #selector(TimePickerView.tapToTurnMonth(ges:)))
        title.addGestureRecognizer(titleTap)

        // 日历区间
        let calendarBGView = UIView(frame: CGRect(x: 0, y: headHeight, width: contentBGView.frame.width, height: tableHeight * CGFloat(rowNum)))
        addSubview(calendarBGView)
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

        calendarView = UIView(frame: CGRect(x: 0, y: headHeight + tableHeight, width: contentBGView.frame.width, height: tableHeight * (CGFloat(rowNum) - 1)))
        addSubview(calendarView)
    }

    func showDateView() {
        // 移除原有的控件
        for item in calendarView.subviews {
            item.removeFromSuperview()
        }
        currentMonthDateArray = []

        let now = Time.now.time

        // 获取本月第一天是星期几
        let dateCom: DateComponents = DateComponents(year: year, month: month, day: 1)
        let calendar = Calendar.current
        let date1 = calendar.date(from: dateCom)!
        let date1Week = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: date1)! - 1

        var w: CGFloat = 0
        var h: CGFloat = 0
        for i in 0 ..< colNum * (rowNum - 1) { // -1 是减去显示星期的一行
            if i % colNum == 0 {
                h += tableHeight
                w = 0
            }

            let dayView = UILabel(frame: CGRect(x: w, y: h, width: tableWidth, height: tableHeight))
            calendarView.addSubview(dayView)
            dayView.tag = i
            dayView.font = UIFont.systemFont(ofSize: 10)
            dayView.textAlignment = .center

            let dayDate = date1.addingTimeInterval(TimeInterval(i - date1Week) * 24 * 3600)
            currentMonthDateArray[i] = dayDate.timeIntervalSince1970

            let dayCom = calendar.dateComponents([.month, .day], from: dayDate)
            let dayIndex = dayCom.day
            if dayDate == now {
                dayView.text = "今天"
                setDayViewUI(dayView, checked: true, enable: true) // 默认选择到今天
                dayView.layer.borderColor = BaseColor.cgColor
                dayView.layer.borderWidth = 1
            } else {
                dayView.text = String(describing: dayIndex)
                setDayViewUI(dayView, checked: false, enable: dayDate > now) // 今天以前禁用
            }

            // 1号下面加月份
            if dayIndex == 1 {
                let monthLabH: CGFloat = 7
                let monthLab = UILabel(frame: CGRect(x: 0, y: tableHeight - monthLabH, width: tableWidth, height: monthLabH))
                dayView.addSubview(monthLab)
                monthLab.textAlignment = .center
                monthLab.font = UIFont.systemFont(ofSize: 7)
                monthLab.textColor = dayView.textColor
                monthLab.text = String(describing: dayCom.month)
                monthLab.tag = 109 // 为了变色时候查找方便
            }

            if dayDate >= now {
                let dayTap = UITapGestureRecognizer(target: self, action: #selector(TimePickerView.tapToTurnDay(ges:)))
                dayView.addGestureRecognizer(dayTap)
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
    }

    func tapToTurnDay(ges: UITapGestureRecognizer) {

    }

    private func setDayViewUI(_ l: UILabel, checked: Bool, enable: Bool) {
        if !enable {
            l.textColor = UIColor(white: 0.17, alpha: 1.0)
            l.backgroundColor = UIColor.clear
        } else if checked {
            l.textColor = UIColor.white
            l.backgroundColor = BaseColor
        } else {
            l.textColor = UIColor(white: 0.75, alpha: 1.0)
            l.backgroundColor = UIColor.clear

        }

        let monthLab = l.viewWithTag(109) as! UILabel?
        monthLab?.textColor = l.textColor
    }
}









