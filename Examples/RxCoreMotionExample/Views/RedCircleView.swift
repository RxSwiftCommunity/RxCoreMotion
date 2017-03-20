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
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 10.0, height: 10.0))
        backgroundColor = UIColor.red
        layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
