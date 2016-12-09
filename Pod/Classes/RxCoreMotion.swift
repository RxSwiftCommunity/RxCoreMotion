//
//  RxCoreMotion
//
//  Created by Carlos García on 23/05/16.
//  Copyright (c) 2016 RxSwiftCommunity  https://github.com/RxSwiftCommunity. All rights reserved.
//

import CoreMotion
import RxSwift

extension CMMotionManager {
    static public func rx_manager(createMotionManager: @escaping () throws -> CMMotionManager = { CMMotionManager() }) -> Observable<MotionManager> {
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
var rotationKey: UInt8      = 0
var magneticFieldKey: UInt8 = 0
var deviceMotionKey: UInt8  = 0
var pedometerKey: UInt8  = 0

extension CMMotionManager {
    public var rx_acceleration: Observable<CMAcceleration> {
        return memoize(key: &accelerationKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }

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

    public var rx_rotationRate: Observable<CMRotationRate> {
        return memoize(key: &rotationKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }

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

    public var rx_magneticField: Observable<CMMagneticField> {
        return memoize(key: &magneticFieldKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }

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

    public var rx_deviceMotion: Observable<CMDeviceMotion> {
        return memoize(key: &deviceMotionKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }

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


extension CMMotionManager {
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

extension CMPedometer {
    public func rxPedometer(from: Date! = Date()) -> Observable<CMPedometerData> {
        return memoize(key: &pedometerKey) {
            Observable.create { [weak self] observer in

                guard let pedometer:CMPedometer = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }
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


    public var rx_pedometer: Observable<CMPedometerData> {
        return memoize(key: &pedometerKey) {
            Observable.create { [weak self] observer in

                guard let pedometer:CMPedometer = self else {
                    observer.on(.completed)
                    return Disposables.create()
                }
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
    public let rotationRate: Observable<CMRotationRate>?
    public let magneticField: Observable<CMMagneticField>?
    public let deviceMotion: Observable<CMDeviceMotion>?

    public init(motionManager: CMMotionManager) {
        if motionManager.isAccelerometerAvailable {
            self.acceleration = motionManager.rx_acceleration
        }
        else {
            self.acceleration = nil
        }

        if motionManager.isGyroAvailable {
            self.rotationRate = motionManager.rx_rotationRate
        }
        else {
            self.rotationRate = nil
        }

        if motionManager.isMagnetometerAvailable {
            self.magneticField = motionManager.rx_magneticField
        }
        else {
            self.magneticField = nil
        }

        if motionManager.isDeviceMotionAvailable {
            self.deviceMotion = motionManager.rx_deviceMotion
        }
        else {
            self.deviceMotion = nil
        }
    }
}
