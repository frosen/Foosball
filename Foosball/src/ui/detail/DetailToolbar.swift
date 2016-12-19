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

class DetailToolbar: BaseToolbar {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init() {
        super.init()
        
    }

    var delegate: DetailToolbarDelegate? = nil
}
