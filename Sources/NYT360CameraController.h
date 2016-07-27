//
//  NYT360CameraController.h
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;

#import "NYT360EulerAngleCalculations.h"

@class SCNView;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

#pragma mark - Initializers

- (instancetype)initWithView:(SCNView *)view;

#pragma mark - Observing Device Motion

- (void)startMotionUpdates;
- (void)stopMotionUpdates;

#pragma mark - Camera Angle Updates

- (void)updateCameraAngle;

#pragma mark - Panning Options

/**
 Changing this property will allow you to suppress undesired range of motion
 along either the x or y axis. For example, y axis input should be suppressed
 when a 360 video is playing inline in a scroll view.
 
 When this property is set, any disallowed axis will cause the current camera
 angles to be clamped to zero for that axis. Existing angles for the any allowed 
 axes will not be affected.
 
 Defaults to NYT360PanningAxisHorizontal & NYT360PanningAxisVertical.
 */
@property (nonatomic, assign) NYT360PanningAxis allowedPanningAxes;

@end

NS_ASSUME_NONNULL_END
