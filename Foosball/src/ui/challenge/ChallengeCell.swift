//
//  ChallengeCell.swift
//  Foosball
//  分两部分组成，event board 和下面的按钮排
//  Created by 卢乐颜 on 16/8/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeCell: UITableViewCell {

    init(reuseIdentifier: String) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        let w: CGFloat = UIScreen.mainScreen().bounds.width
        let h: CGFloat = ChallengeCell.getCellHeight()
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        selectionStyle = .None

        //事件板
        let eventBoard = EventBoard()
        contentView.addSubview(eventBoard)
    }

    // 因为原来自动的selectionStyle会让subview的backgroundcolor变成透明，所以把自动的关闭，自己写一个
    func changeBackGroundColor(selected: Bool) {
        if selected == true {
            backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        } else {
            backgroundColor = UIColor.whiteColor()
        }
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        changeBackGroundColor(highlighted)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        changeBackGroundColor(selected)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    class func getCellHeight() -> CGFloat {
        return 108
    }

}
