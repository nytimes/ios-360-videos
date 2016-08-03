//
//  NYTMotionManagement.h
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import CoreMotion;

@protocol NYTMotionManagement <NSObject>

@property (nonatomic, readonly) BOOL isDeviceMotionAvailable;
@property (nonatomic, readonly) BOOL isDeviceMotionActive;
@property (nonatomic, readonly) CMDeviceMotion *deviceMotion;

- (NSUUID *)startUpdating:(NSTimeInterval)preferredUpdateInterval;

- (void)stopUpdating:(NSUUID *)identifier;

@end
