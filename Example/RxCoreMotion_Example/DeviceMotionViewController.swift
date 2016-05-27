//
//  DeviceMotionViewController.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import CoreMotion
import RxCoreMotion

class DeviceMotionViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let coreMotionManager = CMMotionManager.rx_manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        coreMotionManager
            .flatMap { manager in
                manager.rx_acceleration
            }
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] deviceMotion in
                print(self)
                print(deviceMotion)
            }
            .addDisposableTo(disposeBag)
        
    }
    
}


