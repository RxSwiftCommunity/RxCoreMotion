//
//  RedCircleView.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit

class RedCircleView: UIView {

    init() {
        super.init(frame: CGRectMake(0.0, 0.0, 10.0, 10.0))
        backgroundColor = UIColor.redColor()
        layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
