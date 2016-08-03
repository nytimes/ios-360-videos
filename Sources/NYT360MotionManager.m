//
//  NYT360MotionManager.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360MotionManager.h"

@interface NYT360MotionManager ()

@property (nonatomic, readonly) CMMotionManager *motionManager;

@end

@implementation NYT360MotionManager

#pragma mark - NYTMotionManagement

- (BOOL)isDeviceMotionAvailable {
    return self.motionManager.isDeviceMotionAvailable;
}

- (BOOL)isDeviceMotionActive {
    return self.motionManager.isDeviceMotionActive;
}

- (CMDeviceMotion *)deviceMotion {
    return self.motionManager.deviceMotion;
}

- (NSUUID *)startUpdating:(NSTimeInterval)preferredUpdateInterval {
    return [NSUUID new];
}

- (void)stopUpdating:(NSUUID *)identifier {
    
}

@end
