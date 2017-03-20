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
    let coreMotionManager = CMMotionManager.rx.manager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        coreMotionManager
            .flatMapLatest { manager in
                manager.magneticField ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { magneticField in
                print(magneticField)
            })
            .addDisposableTo(disposeBag)
        
    }
    
}

