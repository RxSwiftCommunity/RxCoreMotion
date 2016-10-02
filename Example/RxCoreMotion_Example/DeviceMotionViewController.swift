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
    let pedometerManager = CMPedometer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        pedometerManager.rxPedometer(from: Date())
//            .flatMapLatest { (data) in
//                print(data.debugDescription)
//            }
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { [weak self] deviceMotion in
//                print(self)
//                print(deviceMotion)
//                })
//            .addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coreMotionManager
            .flatMapLatest { manager in
                manager.acceleration ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] deviceMotion in
                print(self)
                print(deviceMotion)
            })
            .addDisposableTo(disposeBag)
        
    }
    
}


