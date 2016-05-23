//
//  RxCoreMotionManager
//
//  Created by Carlos García on 23/05/16.
//  Copyright (c) 2016 RxSwiftCommunity  https://github.com/RxSwiftCommunity. All rights reserved.
//

import CoreMotion
import RxSwift

private class RxMotionManagerProxie {
    
    static let instance = RxMotionManagerProxie()
    let manager = CMMotionManager()
    
    let accelerometerSubject = BehaviorSubject<CMAcceleration?>(value: nil)
    func accelerometer() -> Observable<CMAcceleration> {
        enableAccelerometerObservation()
        return accelerometerSubject
            .flatMap { $0.map(Observable.just) ?? Observable.empty() }
    }
    
    let gyroSubject = BehaviorSubject<CMRotationRate?>(value: nil)
    func gyro() -> Observable<CMRotationRate> {
        enableGyroObservation()
        return gyroSubject
            .flatMap { $0.map(Observable.just) ?? Observable.empty() }
    }
    
    
    let magnetometerSubject = BehaviorSubject<CMMagneticField?>(value: nil)
    func magnetometer() -> Observable<CMMagneticField> {
        enableMagnetometerObservation()
        return magnetometerSubject
            .flatMap { $0.map(Observable.just) ?? Observable.empty() }
    }
    
    
    let deviceMotionSubject = BehaviorSubject<CMDeviceMotion?>(value: nil)
    func deviceMotion() -> Observable<CMDeviceMotion> {
        enableDeviceMotionObservation()
        return deviceMotionSubject
            .flatMap { $0.map(Observable.just) ?? Observable.empty() }
    }
    
    var nAccelerometerObservers = 0
    var nGyroObservers = 0
    var nMagnetometerObservers = 0
    var nDeviceMotionObservers = 0
    
    init() {
        
    }
    
    // MARK: Enabling
    
    func enableAccelerometerObservation() {
        if manager.accelerometerAvailable && nAccelerometerObservers == 0 {
            manager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMAccelerometerData?, error: NSError?) -> Void in
                guard let data = data else {
                    return
                }
                self.accelerometerSubject.on(.Next(data.acceleration))
            })
        }
        nAccelerometerObservers += 1
    }
    
    func enableGyroObservation() {
        if manager.gyroAvailable && nGyroObservers == 0 {
            manager.startGyroUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMGyroData?, error: NSError?) -> Void in
                guard let data = data else {
                    return
                }
                self.gyroSubject.on(.Next(data.rotationRate))
            })
        }
        nGyroObservers += 1
    }
    
    func enableMagnetometerObservation() {
        if manager.magnetometerAvailable && nMagnetometerObservers == 0 {
            manager.startMagnetometerUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMMagnetometerData?, error: NSError?) -> Void in
                guard let data = data else {
                    return
                }
                self.magnetometerSubject.on(.Next(data.magneticField))
            })
        }
        nMagnetometerObservers += 1
    }
    
    func enableDeviceMotionObservation() {
        if manager.deviceMotionAvailable && nDeviceMotionObservers == 0 {
            manager.startDeviceMotionUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMDeviceMotion?, error: NSError?) -> Void in
                guard let data = data else {
                    return
                }
                self.deviceMotionSubject.on(.Next(data))
            })
        }
        nDeviceMotionObservers += 1
    }
    
    // MARK: Disabling
    
    func disableAccelerometerObservation() {
        if nAccelerometerObservers > 0 { nAccelerometerObservers -= 1 }
        if nAccelerometerObservers == 0 { manager.stopAccelerometerUpdates() }
    }
    
    func disableGyroObservation() {
        if nGyroObservers > 0 { nGyroObservers -= 1 }
        if nGyroObservers == 0 { manager.stopAccelerometerUpdates() }
    }
    
    func disableMagnetometerObservation() {
        if nMagnetometerObservers > 0 { nMagnetometerObservers -= 1 }
        if nMagnetometerObservers == 0 { manager.stopAccelerometerUpdates() }
    }
    
    func disableDeviceMotionObservation() {
        if nDeviceMotionObservers > 0 { nDeviceMotionObservers -= 1 }
        if nDeviceMotionObservers == 0 { manager.stopAccelerometerUpdates() }
    }
    
}

public final class RxCoreMotionManager {
    
    private var disposeBag = DisposeBag()
    
    public init() {
        
    }
    
    public var acceleration: Observable<CMAcceleration> {
        return Observable.create { observer in
            let d = RxMotionManagerProxie.instance.accelerometer()
                .subscribeNext {
                    observer.on(.Next($0))
                }
            
            d.addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable {
                d.dispose()
                RxMotionManagerProxie.instance.disableAccelerometerObservation()
            }
        }
    }
    
    public var rotationRate: Observable<CMRotationRate> {
        return Observable.create { observer in
            let d = RxMotionManagerProxie.instance.gyro()
                .subscribeNext {
                    observer.on(.Next($0))
            }
            
            d.addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable {
                d.dispose()
                RxMotionManagerProxie.instance.disableAccelerometerObservation()
            }
        }
    }
    
    public var magneticField: Observable<CMMagneticField> {
        return Observable.create { observer in
            let d = RxMotionManagerProxie.instance.magnetometer()
                .subscribeNext {
                    observer.on(.Next($0))
            }
            
            d.addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable {
                d.dispose()
                RxMotionManagerProxie.instance.disableAccelerometerObservation()
            }
        }
    }
    
    public var deviceMotion: Observable<CMDeviceMotion> {
        return Observable.create { observer in
            let d = RxMotionManagerProxie.instance.deviceMotion()
                .subscribeNext {
                    observer.on(.Next($0))
            }
            
            d.addDisposableTo(self.disposeBag)
            
            return AnonymousDisposable {
                d.dispose()
                RxMotionManagerProxie.instance.disableAccelerometerObservation()
            }
        }
    }
    
}