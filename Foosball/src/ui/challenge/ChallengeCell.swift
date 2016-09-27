//
//  ChallengeCell.swift
//  Foosball
//  分两部分组成，event board 和下面的按钮排
//  Created by 卢乐颜 on 16/8/6.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class ChallengeCell: BaseCell {
    override class func getCellHeight(_ d: Data? = nil, index: IndexPath? = nil) -> CGFloat {
        return 108
    }

    override func initData(_ d: Data?, index: IndexPath?) {
        bounds = CGRect(x: 0, y: 0, width: w, height: h)

        // 因为原来自动的selectionStyle会让subview的backgroundcolor变成透明，所以把自动的关闭，自己写一个
        selectionStyle = .none

        //事件板
        let eventBoard = EventBoard()
        contentView.addSubview(eventBoard)

        let e = d as! Event
        eventBoard.setData(e)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted == true {
            backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        } else {
            backgroundColor = UIColor.white
        }
    }
}
