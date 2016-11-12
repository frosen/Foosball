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
    var title: UILabel! = nil
    var position: UILabel! = nil
    var createTime: UILabel! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil) -> CGFloat {
        return 72
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        self.selectionStyle = .none //使选中后没有反应

        //图
        let (iconView, _) = EventIcon.create(h, iconMargin: DetailG.iconMargin)
        addSubview(iconView)

        //标题
        let stringOffset: CGFloat = 20
        title = UILabel()
        contentView.addSubview(title)
        title.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.right.equalTo(contentView.snp.right).inset(DetailG.iconMargin)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.3) //0.3 0.7
        }

        title.font = TitleFont
        title.textColor = TitleColor

        // 位置和时间显示
        position = UILabel()
        contentView.addSubview(position)
        position.snp.makeConstraints{ make in
            make.left.equalTo(iconView.snp.right).offset(stringOffset)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        position.font = TextFont
        position.textColor = TextColor

        createTime = UILabel()
        contentView.addSubview(createTime)
        createTime.snp.makeConstraints{ make in
            make.left.equalTo(position.snp.right).offset(20)
            make.centerY.equalTo(contentView.snp.bottom).multipliedBy(0.7) //0.3 0.7
        }

        createTime.font = TextFont
        createTime.textColor = TextColor
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        title.text = "这也是一个很有趣的测试"
        title.sizeToFit()
        position.text = "朝阳/6km"
        position.sizeToFit()
        createTime.text = "1小时前"
        createTime.sizeToFit()
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

    func setLblData(contentView: UIView, str: String) {
        let height = DetailG.calculateLblHeight(str, w: DetailG.widthWithoutMargin)
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

class DetailCashCell: DetailStringCell {
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

// =============================================================================================================

class DetailHeadCell: StaticCell {
    var lbl: UILabel! = nil

    func createHead(_ s: String) {
        let vw: CGFloat = 15
        let vh: CGFloat = 15

        let icon = UIImageView(frame: CGRect(x: DetailG.headMargin, y: contentView.frame.height / 2 - vh / 2, width: vw, height: vh))
        contentView.addSubview(icon)
        icon.image = UIImage(named: "detail_cell_icon")
//        icon.backgroundColor = UIColor.orange

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

    func createButton(_ txt: String, fromPosX: CGFloat, callback: Selector) -> CGFloat {
        let btn = UIButton(type: .system)
        contentView.addSubview(btn)

        let btnWidth: CGFloat = 15.0 * CGFloat(txt.characters.count) + 20.0

        btn.snp.makeConstraints{ make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(contentView.snp.right).inset(DetailG.headMargin + fromPosX)
            make.size.equalTo(CGSize(width: btnWidth, height: 25))
        }

        btn.setTitle(txt, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = BaseColor
        btn.layer.cornerRadius = 9
        btn.addTarget(self, action: callback, for: .touchUpInside)

        return btnWidth + DetailG.headMargin + fromPosX
    }
}

