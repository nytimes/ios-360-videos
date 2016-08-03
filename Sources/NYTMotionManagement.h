//
//  NYTMotionManagement.h
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import CoreMotion;

NS_ASSUME_NONNULL_BEGIN

@protocol NYTMotionManagement <NSObject>

@property (nonatomic, readonly, getter=isDeviceMotionAvailable) BOOL deviceMotionAvailable;
@property (nonatomic, readonly, getter=isDeviceMotionActive) BOOL deviceMotionActive;
@property (nonatomic, readonly, nullable) CMDeviceMotion *deviceMotion;

- (NSUUID *)startUpdating:(NSTimeInterval)preferredUpdateInterval;

- (void)stopUpdating:(NSUUID *)identifier;

@end

NS_ASSUME_NONNULL_END
