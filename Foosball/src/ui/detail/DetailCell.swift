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
    static let contentBottomHeight: CGFloat = 15

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

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应

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
        let urlStr: String? = e.imageURLList.count > 0 ? e.imageURLList[0] : nil
        eventBoard.setData(et: e.type, it: e.item, promise: e.promiseList, urlStr: urlStr)

        let st = UserMgr.getState(from: e, by: APP.userMgr.me.ID)
        set(state: st)
        
        createTime.text = "发布时间：" + e.createTime.toString
    }

    func set(state: EventState) {
        eventBoard.set(state: state)
    }
}

class DetailStringCell: StaticCell {
    var lbl: UILabel! = nil
    func initLblData(contentView: UIView, titleStr: String) {
        //标题
        let title = UILabel(frame: CGRect(
            x: DetailG.headMargin, y: 11,
            width: w - DetailG.headMargin * 2,
            height: 13
        ))
        contentView.addSubview(title)

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

    func setLblData(str: String, w: CGFloat = DetailG.widthWithoutMargin) {
        let height = DetailG.calculateLblHeight(str, w: w)
        lbl.frame = CGRect(x: DetailG.headMargin, y: DetailG.subTitleHeight, width: w, height: height)
        let attri: [String : Any] = [NSParagraphStyleAttributeName: DetailG.paragraphStyle]
        let attriStr = NSAttributedString(string: str, attributes: attri)
        lbl.attributedText = attriStr
    }
}

class DetailContentCell: DetailStringCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        let e = d as! Event
        return DetailG.calculateLblHeight(e.detail, w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "内容：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(str: e.detail)
    }
}

class DetailPromiseCell: DetailStringCell {
    class func createText(from promise: [Promise]) -> String {
        var t = ""
        for i in 0 ..< promise.count {
            t += "~ "
            t += "啦啦啦----你问我从哪里来。"
            t += "\n"
        }
        t += "以上！！"
        return t
    }

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        let e = d as! Event
        let promiseText: String = createText(from: e.promiseList)
        return DetailG.calculateLblHeight(promiseText, w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "奖杯：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(str: DetailPromiseCell.createText(from: e.promiseList))
    }
}

class DetailStringBtnCell: DetailStringCell {
    fileprivate static let widthMinusMapBtn: CGFloat = DetailG.widthWithoutMargin - 50
    fileprivate weak var curEvent: Event! = nil
    fileprivate func setBtn(img: UIImage, action: Selector) {
        let enterMapBtn = UIButton(type: .custom)
        contentView.addSubview(enterMapBtn)
        enterMapBtn.setImage(img.withRenderingMode(.alwaysTemplate), for: .normal)
        enterMapBtn.tintColor = BaseColor
        enterMapBtn.sizeToFit()
        enterMapBtn.center = CGPoint(
            x: w - DetailG.headMargin - enterMapBtn.frame.width / 2 - 15,
            y: h / 2
        )
        enterMapBtn.addTarget(self, action: action, for: .touchUpInside)
    }

    override func initLblData(contentView: UIView, titleStr: String) {
        super.initLblData(contentView: contentView, titleStr: titleStr)

        lbl.frame = CGRect(x: DetailG.headMargin, y: DetailG.subTitleHeight, width: DetailStringBtnCell.widthMinusMapBtn, height: TextFont.lineHeight)
        lbl.numberOfLines = 1
        lbl.lineBreakMode = .byTruncatingTail
    }

    override func setLblData(str: String, w: CGFloat) {
        lbl.text = str
    }
}

class DetailTimeCell: DetailStringBtnCell {
    private var tpv: TimePickerView? = nil
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return TextFont.lineHeight + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动时间：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curEvent = e
        setLblData(str: getTimeString(e: e), w: -1)
        setBtn(img: #imageLiteral(resourceName: "enter_calendar"), action: #selector(DetailTimeCell.onClickEnterCalendarBtn)) // 进入日历按钮
    }

    private func getTimeString(e: Event) -> String {
        var showString = "~ " + e.time.toWholeString

        let intervalTime: Int = e.time.toLeftHourSineNow
        showString += " (剩余大约\(intervalTime)小时)"
        return showString
    }

    func onClickEnterCalendarBtn() {
        print("onClickEnterCalendarBtn")

        if tpv == nil {
            tpv = TimePickerView(t: curEvent.time, parents: ctrlr.view) { t in
                if t == nil || self.onGetTimeFromPicker(t!, e: self.curEvent) {
                    // 动画消失
                    self.tpv!.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.3) {
                        self.tpv!.alpha = 0
                    }
                }

            }
            ctrlr.view.addSubview(tpv!)
            setTimePickerAttri(tpv!)
            tpv!.alpha = 0
        }

        // 动画出现
        self.tpv!.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3) {
            self.tpv!.alpha = 1
        }
    }

    func setTimePickerAttri(_ tpv: TimePickerView) {
        tpv.setChangeDate(enable: false)
    }

    func onGetTimeFromPicker(_ t: Time, e: Event) -> Bool {
        return true
    }
}

class DetailLocationCell: DetailStringBtnCell {

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return TextFont.lineHeight + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动地点：")
        setBtn(img: #imageLiteral(resourceName: "enter_map"), action: #selector(DetailLocationCell.onClickEnterMapBtn)) // 进入地图按钮
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        curEvent = e

        if let adStr = e.location.locString {
            self.setLblData(str: adStr, w: -1)
        } else {
            self.setLblData(str: "位置搜索中", w: -1)

            e.location.getAddress { adStr in
                if adStr != nil {
                    self.setLblData(str: adStr!, w: -1)
                } else {
                    self.setLblData(str: "位置获取有误", w: -1)
                }
            }
        }

    }

    override func setLblData(str: String, w: CGFloat) {
        let newStr = "~ " + str
        super.setLblData(str: newStr, w: w)
    }

    func onClickEnterMapBtn() {
        print("onClickEnterMapBtn")
        createMapVC(e: curEvent)
    }

    func createMapVC(e: Event) {
        let rootVC = (ctrlr as! DetailViewController).rootVC
        let mapVC = MapController(rootVC: rootVC, l: curEvent.location)
        ctrlr.navigationController!.pushViewController(mapVC, animated: true)
    }
}

// =============================================================================================================

class DetailHeadCell: StaticCell {
    class func createHead(_ v: UIView, s: String, h: CGFloat) {
        let vw: CGFloat = 5
        let vh: CGFloat = 15

        let icon = UIView(frame: CGRect(x: DetailG.headMargin, y: v.frame.height / 2 - vh / 2, width: vw, height: vh))
        v.addSubview(icon)
        icon.backgroundColor = BaseColor

        let lbl = UILabel(frame: CGRect(
            x: DetailG.headMargin + icon.frame.width + icon.frame.origin.x,
            y: 0, width: 300, height: h))
        v.addSubview(lbl)

        lbl.text = s

        lbl.textAlignment = .left
        lbl.font = TitleFont
        lbl.textColor = TitleColor
    }
}

