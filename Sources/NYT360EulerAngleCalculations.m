//
//  NYT360EulerAngleCalculations.m
//  NYT360Video
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360EulerAngleCalculations.h"

#pragma mark - Constants

CGFloat const NYT360EulerAngleCalculationNoiseThresholdDefault = 0.12;
float const NYT360EulerAngleCalculationDefaultReferenceCompassAngle = 3.14;

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

static inline float NYT360UnitRotationForCameraRotation(float cameraRotation) {
    
    // Use a modulus so that we don't pass the host application a compass angle
    // value that is greater than one rotation, which wouldn't make sense in the
    // context of a compass animation.
    float oneRotation = 2.0 * M_PI;
    float rawResult = fmodf(cameraRotation, oneRotation);
    
    // `rawResult` will be less than `oneRotation`, but if it's very very close
    // to `oneRotation` than wrap the result back around to zero radians.
    float accuracy = 0.0001;
    float difference = oneRotation - fabsf(rawResult);
    float wrappedAround = (difference < accuracy) ? 0 : rawResult;
    
    return wrappedAround;
}

#pragma mark - Calculations

NYT360EulerAngleCalculationResult NYT360UpdatedPositionAndAnglesForAllowedAxes(CGPoint position, NYT360PanningAxis allowedPanningAxes) {
    position = NYT360AdjustPositionForAllowedAxes(position, allowedPanningAxes);
    SCNVector3 eulerAngles = SCNVector3Make(position.y, position.x, 0);
    return NYT360EulerAngleCalculationResultMake(position, eulerAngles);
}

NYT360EulerAngleCalculationResult NYT360DeviceMotionCalculation(CGPoint position, CMRotationRate rotationRate, UIInterfaceOrientation orientation, NYT360PanningAxis allowedPanningAxes, CGFloat noiseThreshold) {
    
    static CGFloat NYT360EulerAngleCalculationRotationRateDampingFactor = 0.02;
    
    // On some devices, the rotation rates exhibit a low-level drift on one or
    // more rotation axes. The symptom expressions are not identical, but they
    // appear to be related to low component quality (iPhone 5c versus higher
    // end devices) and/or rough usage (drops, etc). In an ideal scenario, we
    // could ask users to calibrate their gyroscopes and apply a corrective
    // factor to all inputs. Barring that, the next best thing we can try is to
    // add a low-pass filter which ignores input less than a given threshold.
    // In my non-scientific testing with the only affected devices at my
    // disposal, I found that a noise threshold between 0.10 and 0.15 filtered
    // out the noise with a minimal loss in sensitivity. Less than 0.10 and the
    // 360 camera position starts to drift.
    // ~ Jared Sinclair, August 1, 2016.
    // See also: https://forums.developer.apple.com/thread/12049
    
    if (fabs(rotationRate.x) < noiseThreshold) {
        rotationRate.x = 0;
    }
    
    if (fabs(rotationRate.y) < noiseThreshold) {
        rotationRate.y = 0;
    }
    
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

CGFloat NYT360OptimalYFovForViewSize(CGSize viewSize) {
    
    static CGFloat NYT360EulerAngleCalculationYFovDefault = 60.0;
    static CGFloat NYT360EulerAngleCalculationYFovMin = 40.0;
    static CGFloat NYT360EulerAngleCalculationYFovMax = 120.0;
    static CGFloat NYT360EulerAngleCalculationYFovFunctionSlope = -33.01365882011044;
    static CGFloat NYT360EulerAngleCalculationYFovFunctionConstant = 118.599244406;
    
    CGFloat yFov;
    if (viewSize.height > 0) {
        CGFloat ratio = viewSize.width / viewSize.height;
        CGFloat slope = NYT360EulerAngleCalculationYFovFunctionSlope;
        yFov = (slope * ratio) + NYT360EulerAngleCalculationYFovFunctionConstant;
        yFov = MIN(MAX(yFov, NYT360EulerAngleCalculationYFovMin), NYT360EulerAngleCalculationYFovMax);
    } else {
        yFov = NYT360EulerAngleCalculationYFovDefault;
    }
    return yFov;
}

float NYT360CompassAngleForEulerAngles(SCNVector3 eulerAngles) {
    return NYT360UnitRotationForCameraRotation((-1.0 * eulerAngles.y) + NYT360EulerAngleCalculationDefaultReferenceCompassAngle);
}
