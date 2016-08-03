//
//  NYT360MotionManagerTests.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import XCTest;

#import "NYT360MotionManager.h"

@interface NYT360MotionManagerTests : XCTestCase

@end

@implementation NYT360MotionManagerTests

- (void)testItDefaultsToANonZeroUpdateInterval {
    XCTAssert([NYT360MotionManager sharedManager].resolvedUpdateInterval > 0, @"It should have a non-zero update interval upon initialization.");
}

- (void)testItPushesAndPopsOneObserver {
    
    NYT360MotionManager *manager = [NYT360MotionManager sharedManager];
    NSTimeInterval initialInterval = manager.resolvedUpdateInterval;
    XCTAssertFalse(manager.isDeviceMotionActive);
    
    NSUUID *identifer = [manager startUpdating:30];
    XCTAssert(manager.resolvedUpdateInterval == 30);
    XCTAssert(manager.numberOfObservers == 1);
    
    [manager stopUpdating:identifer];
    XCTAssert(manager.resolvedUpdateInterval == initialInterval);
    XCTAssert(manager.numberOfObservers == 0);
    XCTAssertFalse(manager.isDeviceMotionActive);
}

- (void)testItPushesAndPopsTwoObservers {
    
    NYT360MotionManager *manager = [NYT360MotionManager sharedManager];
    NSTimeInterval initialInterval = manager.resolvedUpdateInterval;
    XCTAssertFalse(manager.isDeviceMotionActive);
    
    NSUUID *identiferA = [manager startUpdating:1000];
    NSUUID *identiferB = [manager startUpdating:10];
    XCTAssert(manager.resolvedUpdateInterval == 1000);
    XCTAssert(manager.numberOfObservers == 2);
    
    [manager stopUpdating:identiferA];
    XCTAssert(manager.resolvedUpdateInterval == 10);
    XCTAssert(manager.numberOfObservers == 1);
    
    [manager stopUpdating:identiferB];
    XCTAssert(manager.resolvedUpdateInterval == initialInterval);
    XCTAssert(manager.numberOfObservers == 0);
    XCTAssertFalse(manager.isDeviceMotionActive);
}

@end
