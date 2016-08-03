//
//  NYT360MotionManager.h
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import CoreMotion;

#import "NYTMotionManagement.h"

/**
 This is an example implementation of `NYTMotionManagement`. Your application
 can provide another implementation if so desired.
 
 @seealso `NYT360ViewController`.
 */
@interface NYT360MotionManager : NSObject <NYTMotionManagement>

#pragma mark - Singleton

+ (instancetype)sharedManager;

#pragma mark - Internal

- (NSTimeInterval)resolvedUpdateInterval;
- (NSUInteger)numberOfObservers;

@end
