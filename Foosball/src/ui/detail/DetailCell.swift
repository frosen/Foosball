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
    var position: UILabel! = nil
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
        let halfEventConVWidth = eventConV.frame.width / 2
        let eventConVHeight = eventConV.frame.height

        // 位置和时间显示
        position = UILabel(frame: CGRect(x: 0, y: 0, width: halfEventConVWidth, height: eventConVHeight))
        eventConV.addSubview(position)

        position.font = TextFont
        position.textColor = TextColor

        createTime = UILabel(frame: CGRect(x: halfEventConVWidth, y: 0, width: halfEventConVWidth, height: eventConVHeight))
        eventConV.addSubview(createTime)

        createTime.font = TextFont
        createTime.textColor = TextColor
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        eventBoard.setData(e)

        let locationStr = e.location.toString
        position.text = "位置：" + locationStr
        createTime.text = "时间：" + e.operationTimeList[0].time.toString()
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
        lbl.frame = CGRect(x: DetailG.headMargin, y: DetailG.subTitleHeight, width: DetailG.widthWithoutMargin, height: height)
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

class DetailTimeCell: DetailStringCell {

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let str = getTimeString(e: d as! Event)
        return DetailG.calculateLblHeight(str, w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动时间：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: DetailTimeCell.getTimeString(e: e))
    }

    class func getTimeString(e: Event) -> String {
        var showString = "~ " + e.time.toWholeString()
        let intervalTime = ceil(e.time.time.timeIntervalSinceNow / 60)
        showString += " (剩余大约\(intervalTime))"
        return showString
    }
}

class DetailLocationCell: DetailStringCell {
    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        let e = d as! Event
        return DetailG.calculateLblHeight("呵呵呵呵", w: DetailG.widthWithoutMargin) + DetailG.subTitleHeight + DetailG.contentBottomHeight
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应
        initLblData(contentView: contentView, titleStr: "活动地点：")
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        let e = d as! Event
        setLblData(contentView: contentView, str: "呵呵呵呵")
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

