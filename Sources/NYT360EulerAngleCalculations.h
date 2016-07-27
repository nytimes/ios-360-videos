//
//  NYT360EulerAngleCalculations.h
//  ios-360-videos
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;
@import UIKit;
@import SceneKit;
@import CoreMotion;

#pragma mark - Data Types

typedef NS_OPTIONS(NSInteger, NYT360PanningAxis) {
    NYT360PanningAxisHorizontal = 1 << 0,
    NYT360PanningAxisVertical   = 1 << 1
};

struct NYT360EulerAngleCalculationResult {
    CGPoint position;
    SCNVector3 eulerAngles;
};
typedef struct NYT360EulerAngleCalculationResult NYT360EulerAngleCalculationResult;

#pragma mark - Calculations

NYT360EulerAngleCalculationResult NYT360UpdatedPositionAndAnglesForAllowedAxes(CGPoint position, NYT360PanningAxis allowedPanningAxes);

NYT360EulerAngleCalculationResult NYT360DeviceMotionCalculation(CGPoint position, CMRotationRate rotationRate, UIInterfaceOrientation orientation, NYT360PanningAxis allowedPanningAxes);

NYT360EulerAngleCalculationResult NYT360PanGestureChangeCalculation(CGPoint position, CGPoint rotateDelta, CGSize viewSize, NYT360PanningAxis allowedPanningAxes);
