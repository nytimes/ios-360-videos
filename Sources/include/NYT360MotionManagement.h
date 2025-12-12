//
//  NYT360MotionManagement.h
//  NYT360Video
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import CoreMotion;

NS_ASSUME_NONNULL_BEGIN

typedef id<NSObject, NSCopying> NYT360MotionManagementToken;

/**
 Expectations that must be fulfilled by an appliation-wide "wrapper" around
 CMMotionManager for NYT360Video's use.

 Per Apple's documentation, it is recommended that an application will have no
 more than one `CMMotionManager`, otherwise performance could degrade. The
 challenge for the host application using NYT360Video is that there may be
 entities outside of NYT360Video that also require device motion updates. It is
 undesirable that all these entities would have direct access to the same shared
 manager, leading to misconfigurations or a premature call to 
 `stopDeviceMotionUpdates`. To facilitate the use of a shared motion manager 
 without exposing a surface area for misuse, the `NYT360MotionManagement` protocol
 defines a set of expectations for a shared "wrapper" around a shared 
 `CMMotionManager`. The conforming class must ensure that a shared
 `CMMotionManager` is kept private, properly configured, and activated or
 deactivated at the appropriate times.

 A host application is free to provide a custom class conforming to
 `NYT360MotionManagement`. If your application does not use a CMMotionManager 
 outside of NYT360Videos, we recommend that you use the shared instance of 
 `NYT360MotionManager`, a ready-made class that already conforms to 
 `NYT360MotionManagement`.

 @seealso `NYT360MotionManager.h`
 */
@protocol NYT360MotionManagement <NSObject>

/**
 Determines whether device motion hardware and APIs are available.
 */
@property (nonatomic, readonly, getter=isDeviceMotionAvailable) BOOL deviceMotionAvailable;

/**
 Determines whether the receiver is currently providing motion updates.
 */
@property (nonatomic, readonly, getter=isDeviceMotionActive) BOOL deviceMotionActive;

/**
 Returns the latest sample of device motion data, or nil if none is available.
 */
@property (nonatomic, readonly, nullable) CMDeviceMotion *deviceMotion;

/**
 Begins updating device motion, if it hasn't begun already.
 
 @param preferredUpdateInterval The requested update interval. The actual 
 interval used should resolve to the shortest requested interval among the
 active requests.
 
 @return Returns a token which the caller should use to balance this call with a 
 call to `stopUpdating:`.
 
 @warning Callers should balance a call to `startUpdating` with a call to 
 `stopUpdating:`, otherwise device motion will continue to be updated indefinitely.
 */
- (NYT360MotionManagementToken)startUpdating:(NSTimeInterval)preferredUpdateInterval;

/**
 Requests that device motion updates be stopped. If there are other active
 observers that still require device motion updates, motion updates will not be
 stopped.
 
 The device motion update interval may be raised or lowered after a call to
 `stopUpdating:`, as the interval will resolve to the shortest interval among
 the active observers.
 
 @param identifier The token received from a call to `startUpdating`.
 
 @warning Callers should balance a call to `startUpdating` with a call to
 `stopUpdating:`, otherwise device motion will continue to be updated indefinitely.
 */
- (void)stopUpdating:(NYT360MotionManagementToken)token;

@end

NS_ASSUME_NONNULL_END
