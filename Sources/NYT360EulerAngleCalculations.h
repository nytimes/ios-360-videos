//
//  NYT360EulerAngleCalculations.h
//  NYT360Video
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;
@import CoreMotion;

extern CGFloat const NYT360EulerAngleCalculationNoiseThresholdDefault;

#import "NYT360DataTypes.h"

#pragma mark - Data Types

struct NYT360EulerAngleCalculationResult {
    CGPoint position;
    SCNVector3 eulerAngles;
};
typedef struct NYT360EulerAngleCalculationResult NYT360EulerAngleCalculationResult;

#pragma mark - Calculations

NYT360EulerAngleCalculationResult NYT360UpdatedPositionAndAnglesForAllowedAxes(CGPoint position, NYT360PanningAxis allowedPanningAxes);

NYT360EulerAngleCalculationResult NYT360DeviceMotionCalculation(CGPoint position, CMRotationRate rotationRate, UIInterfaceOrientation orientation, NYT360PanningAxis allowedPanningAxes, CGFloat noiseThreshold);

NYT360EulerAngleCalculationResult NYT360PanGestureChangeCalculation(CGPoint position, CGPoint rotateDelta, CGSize viewSize, NYT360PanningAxis allowedPanningAxes);
