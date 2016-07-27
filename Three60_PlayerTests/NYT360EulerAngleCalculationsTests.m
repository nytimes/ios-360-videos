//
//  NYT360EulerAngleCalculationsTests.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import XCTest;
@import CoreMotion;
@import Three60_Player;

@interface NYT360EulerAngleCalculationsTests : XCTestCase

@end

@implementation NYT360EulerAngleCalculationsTests

- (void)testUpdateFunctionShouldZeroOutDisallowedYAxis {
    CGPoint inputA = CGPointMake(100, 100);
    NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(inputA, NYT360PanningAxisHorizontal);
    XCTAssertEqual(result.position.x, 100);
    XCTAssertEqual(result.position.y, 0);
}

- (void)testUpdateFunctionShouldZeroOutDisallowedXAxis {
    CGPoint inputA = CGPointMake(100, 100);
    NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(inputA, NYT360PanningAxisVertical);
    XCTAssertEqual(result.position.x, 0);
    XCTAssertEqual(result.position.y, 100);
}

@end
