//
//  NYT360CameraController.h
//  NYT360Video
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;
@import CoreMotion;

#import "NYT360DataTypes.h"
#import "NYT360MotionManagement.h"

@class NYT360CameraPanGestureRecognizer;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

#pragma mark - Camera Angle Direction

/**
 Returns the latest camera angle direction.
 */
@property (nonatomic, readonly) double cameraAngleDirection;

#pragma mark - Initializers

/**
 Use `initWithView:motionManager:`.
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Designated initializer.
 
 @param view The view whose camera NYT360CameraController will manage.
 
 @param motionManager A class conforming to NYT360MotionManagement. Ideally the
 same motion manager should be shared throughout an application, since multiple 
 active managers can degrade performance.
 
 @seealso: `NYT360MotionManagement.h`
 */
- (instancetype)initWithView:(SCNView *)view motionManager:(id<NYT360MotionManagement>)motionManager NS_DESIGNATED_INITIALIZER;

#pragma mark - Observing Device Motion

- (void)startMotionUpdates;
- (void)stopMotionUpdates;

#pragma mark - Camera Control

/**
 *  Updates the camera angle based on the current device motion. It's assumed that this method will be called many times a second during SceneKit rendering updates.
 */
- (void)updateCameraAngle;

#pragma mark - Panning Options

/**
 *  An otherwise vanilla subclass of UIPanGestureRecognizer used by NYT360Video to enable manual camera panning. This class is exposed so that host applications can more easily configure interaction with other gesture recognizers without having to have references to specific instances of an NYT360Video pan recognizer.
 */
@property (nonatomic, readonly) NYT360CameraPanGestureRecognizer *panRecognizer;


/**
 *  Changing this property will allow you to suppress undesired range of motion along either the x or y axis. For example, y axis input should be suppressed when a 360 video is playing inline in a scroll view.
 
 *  When this property is set, any disallowed axis will cause the current camera angles to be clamped to zero for that axis. Existing angles for the any allowed axes will not be affected.
 
 *  Defaults to NYT360PanningAxisHorizontal | NYT360PanningAxisVertical.
 */
@property (nonatomic, assign) NYT360PanningAxis allowedPanningAxes;

@end

NS_ASSUME_NONNULL_END
