//
//  NYT360MotionManager.h
//  NYT360Video
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import CoreMotion;

#import "NYT360MotionManagement.h"

/**
 This is an example implementation of `NYT360MotionManagement`. Your application
 can provide another implementation if so desired.
 
 @seealso `NYT360ViewController`.
 */
@interface NYT360MotionManager : NSObject <NYT360MotionManagement>

#pragma mark - Singleton

+ (instancetype)sharedManager;

#pragma mark - Internal

- (NSTimeInterval)resolvedUpdateInterval;
- (NSUInteger)numberOfObservers;

@end
