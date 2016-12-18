//
//  DetailToolbar.swift
//  Foosball
//
//  Created by 卢乐颜 on 2016/10/23.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

protocol DetailToolbarDelegate {

}

class DetailToolbar: UIView {
    private static let w: CGFloat = UIScreen.main.bounds.width
    private static let h: CGFloat = 49

    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: DetailToolbar.w, height: DetailToolbar.h))

        backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var delegate: DetailToolbarDelegate? = nil
}
