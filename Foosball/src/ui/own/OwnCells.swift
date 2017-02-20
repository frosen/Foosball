//
//  OwnCells.swift
//  TheOneFoosball2
//
//  Created by 卢乐颜 on 16/7/3.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ScoreView: UIButton {
    private var score: UILabel! = nil

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(center: CGPoint, image: UIImage, titleStr: String) {
        super.init(frame: CGRect.zero)

        let h: CGFloat = 40

        let img = UIImageView(image: image)
        addSubview(img)
        img.frame = CGRect(x: 5, y: 5, width: 30, height: 30)

        let font = UIFont.systemFont(ofSize: 11)

        let title = UILabel()
        addSubview(title)
        title.text = titleStr
        title.sizeToFit()
        title.textColor = TextColor
        title.textAlignment = .center
        title.font = font
        title.frame.origin = CGPoint(x: 35, y: 3)

        score = UILabel()
        addSubview(score)
        score.bounds = title.bounds
        score.frame.origin.y = 18
        score.center.x = title.center.x
        score.text = "0"
        score.textColor = TextColor
        score.textAlignment = .center
        score.font = font

        bounds = CGRect(x: 0, y: 0, width: img.frame.width + title.frame.width, height: h)
        self.center = center
    }

    func setScore(_ num: Int) {
        score.text = String(num)
    }
}

class OwnScoreCell: BaseCell {
    private var totalView: ScoreView! = nil
    private var winView: ScoreView! = nil
    private var controversyView: ScoreView! = nil
    private var CEView: ScoreView! = nil
    private var credibilityView: ScoreView! = nil

    override class func getCellHeight(_ d: BaseData? = nil, index: IndexPath? = nil, otherData: Any? = nil) -> CGFloat {
        return 120
    }

    override func initData(_ d: BaseData?, index: IndexPath?) {
        accessoryType = .none
        selectionStyle = .none

        let linesFrame = [
            CGRect(x: 30, y: 60, width: w - 60, height: 0.5),
            CGRect(x: w / 3, y: 15, width: 0.5, height: 30),
            CGRect(x: w / 3 * 2, y: 15, width: 0.5, height: 30),
            CGRect(x: w / 2, y: 75, width: 0.5, height: 30),
        ]

        for lineFrame in linesFrame {
            let line = UIView(frame: lineFrame)
            contentView.addSubview(line)
            line.backgroundColor = UIColor.lightGray
        }

        // 比赛结果记录
        var tap: UITapGestureRecognizer

        totalView = ScoreView(center: CGPoint(x: w / 6, y: h / 4), image: #imageLiteral(resourceName: "share"), titleStr: "比赛次数")
        contentView.addSubview(totalView)
        tap = UITapGestureRecognizer(target: self, action: #selector(OwnScoreCell.onEnterEventList))
        totalView.addGestureRecognizer(tap)

        winView = ScoreView(center: CGPoint(x: w / 2, y: h / 4), image: #imageLiteral(resourceName: "feedback"), titleStr: "获 胜")
        contentView.addSubview(winView)
        tap = UITapGestureRecognizer(target: self, action: #selector(OwnScoreCell.onEnterEventList))
        winView.addGestureRecognizer(tap)

        controversyView = ScoreView(center: CGPoint(x: w / 6 * 5, y: h / 4), image: #imageLiteral(resourceName: "setting"), titleStr: "存在争议")
        contentView.addSubview(controversyView)
        tap = UITapGestureRecognizer(target: self, action: #selector(OwnScoreCell.onEnterEventList))
        controversyView.addGestureRecognizer(tap)

        // 分数记录
        CEView = ScoreView(center: CGPoint(x: w / 4, y: h / 4 * 3), image: #imageLiteral(resourceName: "share"), titleStr: "战力值")
        contentView.addSubview(CEView)
        tap = UITapGestureRecognizer(target: self, action: #selector(OwnScoreCell.onEnterCEDetail))
        CEView.addGestureRecognizer(tap)

        credibilityView = ScoreView(center: CGPoint(x: w / 4 * 3, y: h / 4 * 3), image: #imageLiteral(resourceName: "setting"), titleStr: "信誉值")
        contentView.addSubview(credibilityView)
        tap = UITapGestureRecognizer(target: self, action: #selector(OwnScoreCell.onEnterCreditDetail))
        credibilityView.addGestureRecognizer(tap)
    }

    override func setData(_ d: BaseData?, index: IndexPath?) {
        totalView.setScore(153)
        winView.setScore(76)
        controversyView.setScore(3)
        CEView.setScore(15300)
        credibilityView.setScore(877)
    }

    func onEnterEventList() {
        print("onEnterEventList")
    }

    func onEnterCEDetail() {
        print("onEnterCEDetail")
    }

    func onEnterCreditDetail() {
        print("onEnterCreditDetail")
    }
}

class OwnNormalCell: UITableViewCell {
    init(id: String) {
        super.init(style: .value1, reuseIdentifier: id)

        textLabel?.font = UIFont.systemFont(ofSize: 13)
        detailTextLabel?.font = UIFont.systemFont(ofSize: 13)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 44
    }

    func setUIData(image img: UIImage, title: String, subTitle: String) {
        imageView!.image = img
        textLabel!.text = title
        detailTextLabel!.text = subTitle
        accessoryType = .disclosureIndicator
    }
}
