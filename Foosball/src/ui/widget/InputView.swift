//
//  InputView.swift
//  Foosball
//
//  Created by luleyan on 16/10/17.
//  Copyright © 2016年 卢乐颜. All rights reserved.
//

import UIKit

class InputView: UIView {
    let h: CGFloat = 44
    var input: UITextField! = nil
    init() {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: h))
        backgroundColor = UIColor.red

        input = UITextField(frame: CGRect(x: 10, y: 5, width: 300, height: 33))
        addSubview(input)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func beginInput() {
        input.resignFirstResponder()
    }

}
