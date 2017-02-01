//
//  GyroscopeViewController.swift
//  RxCoreMotion_Example
//
//  Created by Carlos García on 23/05/16.
//  Copyright © 2016 RxSwiftCommunity - https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import CoreMotion
import RxCoreMotion

class GyroscopeViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let coreMotionManager = CMMotionManager.rx.manager()


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        coreMotionManager
            .flatMapLatest { manager in
                manager.rotationRate ?? Observable.empty()
            }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { rotationRate in
                print(rotationRate)
            })
            .addDisposableTo(disposeBag)
        
    }

}
