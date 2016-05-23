//
//  MagnetometerViewController.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import CoreMotion
import RxCoreMotion

class MagnetometerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let coreMotionManager = RxCoreMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        coreMotionManager.magneticField
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] magneticField in
                print(self)
                print(magneticField)
            }
            .addDisposableTo(disposeBag)
        
    }
    
}

