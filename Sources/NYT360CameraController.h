//
//  NYT360CameraController.h
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;
@import CoreMotion;

#import "NYT360DataTypes.h"
#import "NYTMotionManagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

#pragma mark - Initializers

/**
 Designated initializer.
 
 @param view The view whose camera NYT360CameraController will manage.
 
 @param motionManager Ideally only one CMMotionManager should be shared throughout
 the application, since multiple active managers can degrade performance. 
 NYT360CameraController expects that the motion manager's update interval has
 already been configured. See NYT360CameraControllerPreferredMotionUpdateInterval
 for it's preferred interval.
 */
- (instancetype)initWithView:(SCNView *)view motionManager:(id<NYTMotionManagement>)motionManager NS_DESIGNATED_INITIALIZER;

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
 
 Defaults to NYT360PanningAxisHorizontal | NYT360PanningAxisVertical.
 */
@property (nonatomic, assign) NYT360PanningAxis allowedPanningAxes;

@end

NS_ASSUME_NONNULL_END
