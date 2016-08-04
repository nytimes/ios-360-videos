//
//  NYT360EulerAngleCalculationsTests.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import XCTest;

#import "NYT360DataTypes.h"
#import "NYT360EulerAngleCalculations.h"

@interface NYT360EulerAngleCalculationsTests : XCTestCase

@end

@implementation NYT360EulerAngleCalculationsTests

- (void)testUpdateFunctionShouldZeroOutDisallowedYAxis {
    CGPoint position = CGPointMake(100, 100);
    NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(position, NYT360PanningAxisHorizontal);
    XCTAssertEqual(result.position.x, 100);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testUpdateFunctionShouldZeroOutDisallowedXAxis {
    CGPoint position = CGPointMake(100, 100);
    NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(position, NYT360PanningAxisVertical);
    XCTAssertEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 100);
}

- (void)testDeviceMotionFunctionShouldZeroOutDisallowedYAxis {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = 1000;
    rate.y = -1000;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisHorizontal, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertNotEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testDeviceMotionFunctionShouldZeroOutDisallowedXAxis {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = 1000;
    rate.y = -1000;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisVertical, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertEqual(result.position.x, 0);
    XCTAssertNotEqual(result.position.y, 0);
}

- (void)testDeviceMotionFunctionShouldFilterOutNegativeXRotationNoise {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = NYT360EulerAngleCalculationNoiseThresholdDefault * -0.5;
    rate.y = NYT360EulerAngleCalculationNoiseThresholdDefault * 2;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisHorizontal, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertEqual(result.position.x, position.x);
    XCTAssertNotEqual(result.position.y, position.y);
}

- (void)testDeviceMotionFunctionShouldFilterOutPositiveXRotationNoise {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = NYT360EulerAngleCalculationNoiseThresholdDefault * 0.5;
    rate.y = NYT360EulerAngleCalculationNoiseThresholdDefault * 2;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisHorizontal, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertEqual(result.position.x, position.x);
    XCTAssertNotEqual(result.position.y, position.y);
}

- (void)testDeviceMotionFunctionShouldFilterOutNegativeYRotationNoise {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = NYT360EulerAngleCalculationNoiseThresholdDefault * 2;
    rate.y = NYT360EulerAngleCalculationNoiseThresholdDefault * -0.5;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisHorizontal, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertNotEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testDeviceMotionFunctionShouldFilterOutPositiveYRotationNoise {
    CGPoint position = CGPointMake(100, 100);
    CMRotationRate rate;
    rate.x = NYT360EulerAngleCalculationNoiseThresholdDefault * 2;
    rate.y = NYT360EulerAngleCalculationNoiseThresholdDefault * 0.5;
    rate.z = 10;
    UIInterfaceOrientation orientation = UIInterfaceOrientationLandscapeLeft;
    NYT360EulerAngleCalculationResult result = NYT360DeviceMotionCalculation(position, rate, orientation, NYT360PanningAxisHorizontal, NYT360EulerAngleCalculationNoiseThresholdDefault);
    XCTAssertNotEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testPanGestureChangeFunctionShouldZeroOutDisallowedYAxis {
    CGPoint position = CGPointMake(100, 100);
    CGPoint delta = CGPointMake(1000, -1000);
    CGSize viewSize = CGSizeMake(536, 320);
    NYT360EulerAngleCalculationResult result = NYT360PanGestureChangeCalculation(position, delta, viewSize, NYT360PanningAxisHorizontal);
    XCTAssertNotEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testPanGestureChangeFunctionShouldZeroOutDisallowedXAxis {
    CGPoint position = CGPointMake(100, 100);
    CGPoint delta = CGPointMake(1000, -1000);
    CGSize viewSize = CGSizeMake(536, 320);
    NYT360EulerAngleCalculationResult result = NYT360PanGestureChangeCalculation(position, delta, viewSize, NYT360PanningAxisVertical);
    XCTAssertEqual(result.position.x, 0);
    XCTAssertNotEqual(result.position.y, 0);
}


@end
