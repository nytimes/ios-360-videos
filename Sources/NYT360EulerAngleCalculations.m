//
//  NYT360EulerAngleCalculations.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360EulerAngleCalculations.h"

#pragma mark - Constants

static CGFloat NYT360EulerAngleCalculationRotationRateDampingFactor = 0.02;

#pragma mark - Inline Functions

static inline CGFloat NYT360Clamp(CGFloat x, CGFloat low, CGFloat high) {
    return (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)));
}

static inline NYT360EulerAngleCalculationResult NYT360EulerAngleCalculationResultMake(CGPoint position, SCNVector3 eulerAngles) {
    NYT360EulerAngleCalculationResult result;
    result.position = position;
    result.eulerAngles = eulerAngles;
    return result;
}

static inline CGPoint NYT360AdjustPositionForAllowedAxes(CGPoint position, NYT360PanningAxis allowedPanningAxes) {
    BOOL suppressXaxis = (allowedPanningAxes & NYT360PanningAxisHorizontal) == 0;
    BOOL suppressYaxis = (allowedPanningAxes & NYT360PanningAxisVertical) == 0;
    if (suppressXaxis) {
        position.x = 0;
    }
    if (suppressYaxis) {
        position.y = 0;
    }
    return position;
}

#pragma mark - Calculations

NYT360EulerAngleCalculationResult NYT360UpdatedPositionAndAnglesForAllowedAxes(CGPoint position, NYT360PanningAxis allowedPanningAxes) {
    position = NYT360AdjustPositionForAllowedAxes(position, allowedPanningAxes);
    SCNVector3 eulerAngles = SCNVector3Make(position.y, position.x, 0);
    return NYT360EulerAngleCalculationResultMake(position, eulerAngles);
}

NYT360EulerAngleCalculationResult NYT360DeviceMotionCalculation(CGPoint position, CMRotationRate rotationRate, UIInterfaceOrientation orientation, NYT360PanningAxis allowedPanningAxes) {
    
    CGFloat damping = NYT360EulerAngleCalculationRotationRateDampingFactor;
    
    // TODO: [thiago] I think this can be simplified later
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            position = CGPointMake(position.x + rotationRate.x * damping * -1,
                                   position.y + rotationRate.y * damping);
        }
        else {
            position = CGPointMake(position.x + rotationRate.x * damping,
                                   position.y + rotationRate.y * damping * -1);
        }
    }
    else {
        position = CGPointMake(position.x + rotationRate.y * damping,
                               position.y - rotationRate.x * damping * -1);
    }
    position = CGPointMake(position.x,
                           NYT360Clamp(position.y, -M_PI / 2, M_PI / 2));
    
    // Zero-out these values here rather than above, since that would over-
    // complicate the if/else logic or require unreadable numbers of ternary
    // operators.
    position = NYT360AdjustPositionForAllowedAxes(position, allowedPanningAxes);
    
    SCNVector3 eulerAngles = SCNVector3Make(position.y, position.x, 0);
    
    return NYT360EulerAngleCalculationResultMake(position, eulerAngles);
}

NYT360EulerAngleCalculationResult NYT360PanGestureChangeCalculation(CGPoint position, CGPoint rotateDelta, CGSize viewSize, NYT360PanningAxis allowedPanningAxes) {
    
    // TODO: [jaredsinclair] Consider adding constants for the multipliers.
    
    // The y multiplier is 0.4 and not 0.5 because 0.5 felt too uncomfortable.
    position = CGPointMake(position.x + 2 * M_PI * rotateDelta.x / viewSize.width * 0.5,
                           position.y + 2 * M_PI * rotateDelta.y / viewSize.height * 0.4);
    position.y = NYT360Clamp(position.y, -M_PI / 2, M_PI / 2);
    
    position = NYT360AdjustPositionForAllowedAxes(position, allowedPanningAxes);
    
    SCNVector3 eulerAngles = SCNVector3Make(position.y, position.x, 0);
    
    return NYT360EulerAngleCalculationResultMake(position, eulerAngles);
}
