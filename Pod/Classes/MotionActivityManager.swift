//
//  MotionActivityManager.swift
//  Pods
//
//  Created by Francisco Gonçalves on 03/05/2017.
//
//

import CoreMotion
import RxSwift

extension Reactive where Base: CMMotionActivityManager {
    static public func manager(createActivityManager: @escaping () throws -> CMMotionActivityManager = { CMMotionActivityManager() }) -> Observable<MotionActivityManager> {
        return Observable.create { observer in
            do {
                let activityManager = try createActivityManager()
                observer.on(.next(MotionActivityManager(motionActivityManager: activityManager)))
            }
            catch let e {
                observer.on(.error(e))
            }
            return Disposables.create()
            }.shareReplayLatestWhileConnected()
    }
}

var motionActivityKey: UInt8  = 0

extension Reactive where Base: CMMotionActivityManager {
    public var motionActivity: Observable<CMMotionActivity> {
        return memoize(key: &motionActivityKey) {
            Observable.create { observer in
                let activityManager = self.base
                activityManager.startActivityUpdates(to: OperationQueue(), withHandler: { (data) in
                    guard let data = data else {
                        return
                    }
                    observer.on(.next(data))
                })

                return Disposables.create() {
                    activityManager.stopActivityUpdates()
                }
                }
                .shareReplayLatestWhileConnected()
        }
    }
}


extension Reactive where Base: CMMotionActivityManager {
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
public struct MotionActivityManager {
    public let motionActivity: Observable<CMMotionActivity>?

    public init(motionActivityManager: CMMotionActivityManager) {
        if CMMotionActivityManager.isActivityAvailable() {
            self.motionActivity = motionActivityManager.rx.motionActivity
        }
        else {
            self.motionActivity = nil
        }
    }
}
