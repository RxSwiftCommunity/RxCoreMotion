//
//  RxCoreMotion
//
//  Created by Carlos García on 23/05/16.
//  Copyright (c) 2016 RxSwiftCommunity  https://github.com/RxSwiftCommunity. All rights reserved.
//

import CoreMotion
import RxSwift

extension CMMotionManager {
    static public func rx_manager(createMotionManager: () throws -> CMMotionManager = { CMMotionManager() }) -> Observable<CMMotionManager> {
        return Observable.create { observer in
            do {
                let motionManager = try createMotionManager()
                observer.on(.Next(motionManager))
            }
            catch let e {
                observer.on(.Error(e))
            }
            return AnonymousDisposable {
            }
        }.shareReplayLatestWhileConnected()
    }
}


var accelerationKey: UInt8  = 0
var rotationKey: UInt8      = 0
var magneticFieldKey: UInt8 = 0
var deviceMotionKey: UInt8  = 0

extension CMMotionManager {
    public var rx_acceleration: Observable<CMAcceleration> {
        return memoize(&accelerationKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.Completed)
                    return NopDisposable.instance
                }

                motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMAccelerometerData?, error: NSError?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.Next(data.acceleration))
                })

                return AnonymousDisposable {
                    motionManager.stopAccelerometerUpdates()
                }
            }
            .shareReplayLatestWhileConnected()
        }
    }
    
    public var rx_rotationRate: Observable<CMRotationRate> {
        return memoize(&rotationKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.Completed)
                    return NopDisposable.instance
                }

                motionManager.startGyroUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMGyroData?, error: NSError?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.Next(data.rotationRate))
                })

                return AnonymousDisposable {
                    motionManager.stopGyroUpdates()
                }
            }
            .shareReplayLatestWhileConnected()
        }
    }
    
    public var rx_magneticField: Observable<CMMagneticField> {
        return memoize(&magneticFieldKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.Completed)
                    return NopDisposable.instance
                }

                motionManager.startMagnetometerUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMMagnetometerData?, error: NSError?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.Next(data.magneticField))
                })

                return AnonymousDisposable {
                    motionManager.stopMagnetometerUpdates()
                }
            }
            .shareReplayLatestWhileConnected()
        }
    }
    
    public var rx_deviceMotion: Observable<CMDeviceMotion> {
        return memoize(&deviceMotionKey) {
            Observable.create { [weak self] observer in
                guard let motionManager = self else {
                    observer.on(.Completed)
                    return NopDisposable.instance
                }

                motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue(), withHandler: { (data: CMDeviceMotion?, error: NSError?) -> Void in
                    guard let data = data else {
                        return
                    }
                    observer.on(.Next(data))
                })

                return AnonymousDisposable {
                    motionManager.stopDeviceMotionUpdates()
                }
            }
            .shareReplayLatestWhileConnected()
        }
    }
}

extension CMMotionManager {
    func memoize<D>(key: UnsafePointer<Void>, createLazily: () -> Observable<D>) -> Observable<D> {
        objc_sync_enter(self); defer { objc_sync_exit(self) }

        if let sequence = objc_getAssociatedObject(self, key) as? Observable<D> {
            return sequence
        }

        let sequence = createLazily()
        objc_setAssociatedObject(self, key, sequence, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        return sequence
    }
}
