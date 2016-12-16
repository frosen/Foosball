//
//  DetailCell.swift
//  Foosball
//
//  Created by luleyan on 16/9/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

// detail cell 中的全局变量和函数 ------------------------------------------------------------------------

class DetailG {
    static let headMargin: CGFloat = 15
    static let iconMargin: CGFloat = 6 //图标到边的距离
    static let widthWithoutMargin: CGFloat = UIScreen.main.bounds.width - 2 * headMargin

    static let subTitleHeight: CGFloat = 35
    static let contentBottomHeight: CGFloat = 12

    static let opt: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    static var paragraphStyle: NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.headIndent = 12
        return paragraphStyle
    }

    static var lblStyleAttri: [String : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.headIndent = 12

        let attri: [String : Any] = [
            NSFontAttributeName: TextFont,
            NSParagraphStyleAttributeName: paragraphStyle
        ]

        return attri
    }

    class func calculateLblHeight(_ s: String, w: CGFloat, style: [String : Any]? = nil) -> CGFloat {
        let str = s as NSString
        let attri = style != nil ? style : lblStyleAttri
        let size = str.boundingRect(with: CGSize(width: w, height: CGFloat(MAXFLOAT)), options: opt, attributes: attri, context: nil)
        return size.height
    }
}

// -------------------------------------------------------------------------------------------------------

class DetailTitleCell: StaticCell {
    var eventBoard: EventBoard! = nil
    var createTime: UILabel! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //事件板
        eventBoard = EventBoard()
        contentView.addSubview(eventBoard)
        
        let eventConV = eventBoard.contentView!
        let EventConVWidth = eventConV.frame.width
        let eventConVHeight = eventConV.frame.height

        // 位置和时间显示
        createTime = UILabel(frame: CGRect(x: 0, y: 0, width: EventConVWidth, height: eventConVHeight))
        eventConV.addSubview(createTime)

        createTime.font = TextFont
        createTime.textColor = TextColor
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        eventBoard.setData(e)
        createTime.text = "发布时间：" + e.operationTimeList[0].time.toString
    }
}

class DetailStringCell: StaticCell {
    var lbl: UILabel! = nil
    func initLblData(contentView: UIView, titleStr: String) {
        //标题
        let title = UILabel()
        contentView.addSubview(title)

        title.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(11)
            make.left.equalTo(contentView.snp.left).offset(DetailG.headMargin)
        }
        title.font = TextFont
        title.textColor = SubTitleColor

        title.text = titleStr

        // 内容
        lbl = UILabel()
        contentView.addSubview(lbl)

        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byCharWrapping

        lbl.font = TextFont
    }

    func setLblData(contentView: UIView, str: String, w: CGFloat = DetailG.widthWithoutMargin) {
        let height = DetailG.calculateLblHeight(str, w: w)
        lbl.frame = CGRect(x: DetailG.headMargin, y: DetailG.subTitleHeight, width: w, height: height)
        let attri: [String : Any] = [NSParagraphStyleAttributeName: DetailG.paragraphStyle]
        let attriStr = NSAttributedString(string: str, attributes: attri)
        lbl.attributedText = attriStr
    }
}

class DetailContentCell: DetailStringCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        return DetailG.calculateLblHeight(e.detail, w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "内容：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: e.detail)
    }
}

class DetailWagerCell: DetailStringCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        return DetailG.calculateLblHeight(e.award, w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "奖杯：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: e.award)
    }
}

class DetailStringBtnCell: DetailStringCell {
    fileprivate static let widthMinusMapBtn: CGFloat = DetailG.widthWithoutMargin - 80

    fileprivate func setBtn(name: String, action: Selector) {
        let enterMapBtn = UIButton(type: .custom)
        contentView.addSubview(enterMapBtn)
        enterMapBtn.setImage(UIImage(named: name)!.withRenderingMode(.alwaysTemplate), for: .normal)
        enterMapBtn.tintColor = BaseColor
        enterMapBtn.sizeToFit()
        enterMapBtn.center = CGPoint(
            x: w - DetailG.headMargin - enterMapBtn.frame.width / 2 - 15,
            y: h / 2
        )
        enterMapBtn.addTarget(self, action: action, for: .touchUpInside)
    }
}

class DetailTimeCell: DetailStringBtnCell {
    private weak var curEvent: Event! = nil
    private var tpv: TimePickerView? = nil
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let str = getTimeString(e: d as! Event)
        return DetailG.calculateLblHeight(str, w: widthMinusMapBtn) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动时间：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curEvent = e
        setLblData(contentView: contentView, str: DetailTimeCell.getTimeString(e: e), w: DetailLocationCell.widthMinusMapBtn)
        setBtn(name: "enter_calendar", action: #selector(DetailTimeCell.onClickEnterCalendarBtn)) // 进入日历按钮
    }

    private class func getTimeString(e: Event) -> String {
        var showString = "~ " + e.time.toWholeString
        let intervalTime: Int = Int(floor(e.time.time.timeIntervalSinceNow / 3600))
        showString += " (剩余大约\(intervalTime)小时)"
        return showString
    }

    func onClickEnterCalendarBtn() {
        print("onClickEnterCalendarBtn")

        if tpv == nil {
            tpv = TimePickerView(date: curEvent.time.time, parents: ctrlr.view) { date in
                // 动画消失
                self.tpv!.isUserInteractionEnabled = false
                UIView.animate(withDuration: 0.3) {
                    self.tpv!.alpha = 0
                }
            }
            ctrlr.view.addSubview(tpv!)
            tpv!.setChangeDate(enable: false)
            tpv!.alpha = 0
        }

        // 动画出现
        self.tpv!.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.tpv!.alpha = 1
        }
    }
}

class DetailLocationCell: DetailStringBtnCell {

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return DetailG.calculateLblHeight(getLocString(e: d as! Event), w: widthMinusMapBtn) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动地点：")
        setBtn(name: "enter_map", action: #selector(DetailLocationCell.onClickEnterMapBtn)) // 进入地图按钮
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let str = DetailLocationCell.getLocString(e: d as! Event)
        setLblData(contentView: contentView, str: str, w: DetailLocationCell.widthMinusMapBtn)
    }

    private class func getLocString(e: Event) -> String {
        let showString = "~ " + e.location.toString
        return showString
    }

    func onClickEnterMapBtn() {
        print("onClickEnterMapBtn")

        let mapVC = MapController()
        mapVC.rootVC = (ctrlr as! DetailViewController).rootVC
        ctrlr.navigationController!.pushViewController(mapVC, animated: true)
    }
}

// =============================================================================================================

class DetailHeadCell: StaticCell {
    var lbl: UILabel! = nil

    func createHead(_ s: String) {
        let vw: CGFloat = 5
        let vh: CGFloat = 15

        let icon = UIView(frame: CGRect(x: DetailG.headMargin, y: contentView.frame.height / 2 - vh / 2, width: vw, height: vh))
        contentView.addSubview(icon)
        icon.backgroundColor = BaseColor

        lbl = UILabel()
        contentView.addSubview(lbl)
        lbl.snp.makeConstraints{ make in
            make.left.equalTo(icon.snp.right).offset(DetailG.headMargin)
            make.centerY.equalTo(contentView.snp.centerY)
        }

        lbl.text = s
        lbl.sizeToFit()

        lbl.font = TitleFont
        lbl.textColor = TitleColor
    }
}

