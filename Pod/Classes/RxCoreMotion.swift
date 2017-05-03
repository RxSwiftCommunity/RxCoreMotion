//
//  RxCoreMotion
//
//  Created by Carlos García on 23/05/16.
//  Copyright (c) 2016 RxSwiftCommunity  https://github.com/RxSwiftCommunity. All rights reserved.
//
import CoreMotion
import RxSwift

extension Reactive where Base: CMMotionManager {
    static public func manager(createMotionManager: @escaping () throws -> CMMotionManager = { CMMotionManager() }) -> Observable<MotionManager> {
        return Observable.create { observer in
            do {
                let motionManager = try createMotionManager()
                observer.on(.next(MotionManager(motionManager: motionManager)))
            }
            catch let e {
                observer.on(.error(e))
            }
            return Disposables.create()
            }.shareReplayLatestWhileConnected()
    }
}

var accelerationKey: UInt8  = 0
var accelerometerDataKey: UInt8  = 0
var rotationKey: UInt8      = 0
var magneticFieldKey: UInt8 = 0
var deviceMotionKey: UInt8  = 0
var pedometerKey: UInt8  = 0

extension Reactive where Base: CMMotionManager {
    public var acceleration: Observable<CMAcceleration> {
        return memoize(key: &accelerationKey) {
            Observable.create { observer in
                let motionManager = self.base
                
                motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler: { (data: CMAccelerometerData?, error: Error?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data.acceleration))
                })
                
                return Disposables.create() {
                    motionManager.stopAccelerometerUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
    
    public var accelerometerData: Observable<CMAccelerometerData> {
        return memoize(key: &accelerometerDataKey) {
            Observable.create { observer in
                let motionManager = self.base
                
                motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler: { (data: CMAccelerometerData?, error: Error?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data))
                })
                
                return Disposables.create() {
                    motionManager.stopAccelerometerUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }

    public var rotationRate: Observable<CMRotationRate> {
        return memoize(key: &rotationKey) {
            Observable.create { observer in
                let motionManager = self.base
                
                motionManager.startGyroUpdates(to: OperationQueue(), withHandler: { (data: CMGyroData?, error: Error?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data.rotationRate))
                })
                
                return Disposables.create() {
                    motionManager.stopGyroUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
    
    public var magneticField: Observable<CMMagneticField> {
        return memoize(key: &magneticFieldKey) {
            Observable.create { observer in
                let motionManager = self.base
                
                motionManager.startMagnetometerUpdates(to: OperationQueue(), withHandler: { (data: CMMagnetometerData?, error: Error?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data.magneticField))
                })
                
                return Disposables.create() {
                    motionManager.stopMagnetometerUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
    
    public var deviceMotion: Observable<CMDeviceMotion> {
        return memoize(key: &deviceMotionKey) {
            Observable.create { observer in
                let motionManager = self.base
                
                motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: { (data: CMDeviceMotion?, error: Error?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data))
                })
                
                return Disposables.create() {
                    motionManager.stopDeviceMotionUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
}


extension Reactive where Base: CMMotionManager {
    func memoize<D>(key: UnsafeRawPointer, createLazily: () -> Observable<D>) -> Observable<D> {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if let sequence = objc_getAssociatedObject(self, key) as? Observable<D> {
            return sequence
        }
        
        let sequence = createLazily()
        objc_setAssociatedObject(self, key, sequence, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return sequence
    }
}

extension Reactive where Base: CMPedometer {
    public func pedometer(from: Date! = Date()) -> Observable<CMPedometerData> {
        return memoize(key: &pedometerKey) {
            Observable.create { observer in
                let pedometer = self.base
                
                pedometer.startUpdates(from: from, withHandler: {(data, error) in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data))
                })
                return Disposables.create() {
                    pedometer.stopUpdates()
                    if #available(iOS 10.0, *) {
                        pedometer.stopEventUpdates()
                    }
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
    
    
    public var pedometer: Observable<CMPedometerData> {
        return memoize(key: &pedometerKey) {
            Observable.create { observer in
                let pedometer = self.base
                
                pedometer.startUpdates(from: Date(), withHandler: {(data, error) in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data))
                })
                return Disposables.create() {
                    pedometer.stopUpdates()
                    if #available(iOS 10.0, *) {
                        pedometer.stopEventUpdates()
                    }
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
    
    func memoize<D>(key: UnsafeRawPointer, createLazily: () -> Observable<D>) -> Observable<D> {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if let sequence = objc_getAssociatedObject(self, key) as? Observable<D> {
            return sequence
        }
        
        let sequence = createLazily()
        objc_setAssociatedObject(self, key, sequence, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return sequence
    }
}


// If the current device supports one of the capabilities, observable sequence will not be nil
public struct MotionManager {
    public let acceleration: Observable<CMAcceleration>?
    public let accelerometerData: Observable<CMAccelerometerData>?
    public let rotationRate: Observable<CMRotationRate>?
    public let magneticField: Observable<CMMagneticField>?
    public let deviceMotion: Observable<CMDeviceMotion>?
    
    public init(motionManager: CMMotionManager) {
        if motionManager.isAccelerometerAvailable {
            self.acceleration = motionManager.rx.acceleration
            self.accelerometerData = motionManager.rx.accelerometerData
        }
        else {
            self.acceleration = nil
            self.accelerometerData = nil
        }
        
        if motionManager.isGyroAvailable {
            self.rotationRate = motionManager.rx.rotationRate
        }
        else {
            self.rotationRate = nil
        }
        
        if motionManager.isMagnetometerAvailable {
            self.magneticField = motionManager.rx.magneticField
        }
        else {
            self.magneticField = nil
        }
        
        if motionManager.isDeviceMotionAvailable {
            self.deviceMotion = motionManager.rx.deviceMotion
        }
        else {
            self.deviceMotion = nil
        }
    }
}
