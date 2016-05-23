//
//  AccelerometerViewController.swift
//  RxCoreMotion
//
//  Created by Carlos García on 22/05/16.
//  Copyright © 2016 RxSwiftCommunity  https://github.com/RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import CoreMotion
import RxCoreMotion

class AccelerometerViewController: UIViewController {
    
    @IBOutlet weak var grillageView: GrillageView!
    
    let disposeBag = DisposeBag()
    let coreMotionManager = RxCoreMotionManager()
    
    let circleView = RedCircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(circleView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let grillageCenter = grillageView.center
        circleView.center = grillageCenter
        
        coreMotionManager.acceleration
            .observeOn(MainScheduler.instance)
            .subscribeNext { [weak self] acceleration in
                // translate 1G to 100 points
                let xG = CGFloat(acceleration.x) * 100
                let yG = -CGFloat(acceleration.y) * 100
                
                let xPos = grillageCenter.x + xG
                let yPos = grillageCenter.y + yG
                self?.circleView.center = CGPointMake(xPos, yPos)
            }
            .addDisposableTo(disposeBag)
        
    }
    
}
