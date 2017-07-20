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
extern float const NYT360EulerAngleCalculationDefaultReferenceCompassAngle;

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

CGFloat NYT360OptimalYFovForViewSize(CGSize viewSize);

/** 
 *  Unless the host application needs a non-zero reference angle (zero is the default), we want an input camera rotation of 0 to yield a compass angle of 0 where 0 is pointing "due north".
 *
 *  The y component of the SCNVector3 is positive in the counter-clockwise direction, whereas UIKit rotation transforms are positive in the clockwise direction. Thus we want to map camera rotation values to compass angle values by mapping them to the equivalent rotation transform in the opposite direction.
 *
 *  For example, a positive quarter turn of the camera is equivalent to a negative quarter turn of a rotation transform, or:
 *
 *      0.25 cam rotations -> -0.25 rotation transform rotations
 *
 *  or in their raw radian values:
 *
 *      1.571 camera radians -> -1.571 rotation transform radians
 *
 *  Input values in excess of one rotation will be mapped to an equivalent value within the range of plus or minus one radian, such that output values will exceed one rotation. Input values equal (or very very close to equal) to a multiple of one radian (positive or negative) will be mapped to 0.
 */
float NYT360CompassAngleForEulerAngles(SCNVector3 eulerAngles);
