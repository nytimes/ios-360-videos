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
@class NYT360CameraController;

/**
 * The block type used for compass angle updates.
 *
 *  @param compassAngle The compass angle in radians.
 */
typedef void(^NYT360CompassAngleUpdateBlock)(float compassAngle);

NS_ASSUME_NONNULL_BEGIN

@protocol NYT360CameraControllerDelegate <NSObject>

/**
 *  Called the first time the user moves the camera.
 *
 *  @note This method is called synchronously when the camera angle is updated; an implementation should return quickly to avoid performance implications. 
 *
 *  @param controller   The camera controller with which the user interacted.
 *  @param method       The method by which the user moved the camera.
 */
- (void)cameraController:(NYT360CameraController *)controller userInitallyMovedCameraViaMethod:(NYT360UserInteractionMethod)method;

@end

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

/**
 *  The delegate of the controller.
 */
@property (nullable, nonatomic, weak) id <NYT360CameraControllerDelegate> delegate;

#pragma mark - Compass Angle

/**
 *  Returns the current compass angle in radians
 */
@property (nonatomic, readonly) float compassAngle;

/**
 *  A block invoked whenever the compass angle has been updated.
 *
 *  @note This method is called synchronously from SCNSceneRendererDelegate. Its implementation should return quickly to avoid performance implications.
 */
@property (nonatomic, copy, nullable) NYT360CompassAngleUpdateBlock compassAngleUpdateBlock;

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
- (void)updateCameraAngleForCurrentDeviceMotion;

/**
 *  Updates the yFov of the camera to provide the optimal viewing angle for a given view size. Portrait videos will use a wider angle than landscape videos.
 */
- (void)updateCameraFOV:(CGSize)viewSize;

/**
 *  Reorients the camera's vertical angle component so it's pointing directly at the horizon.
 *
 *  @param animated Passing `YES` will animate the change with a standard duration.
 */
- (void)reorientVerticalCameraAngleToHorizon:(BOOL)animated;

#pragma mark - Panning Options

/**
 *  An otherwise vanilla subclass of UIPanGestureRecognizer used by NYT360Video to enable manual camera panning. This class is exposed so that host applications can more easily configure interaction with other gesture recognizers without having to have references to specific instances of an NYT360Video pan recognizer.
 */
@property (nonatomic, readonly) NYT360CameraPanGestureRecognizer *panRecognizer;


/**
 *  Changing this property will allow you to suppress undesired range of motion along either the x or y axis for device motion input. For example, y axis input might be suppressed when a 360 video is playing inline in a scroll view.
 
 *  When this property is set, any disallowed axis will cause the current camera angles to be clamped to zero for that axis. Existing angles for the any allowed axes will not be affected.
 
 *  Defaults to NYT360PanningAxisHorizontal | NYT360PanningAxisVertical.
 */
@property (nonatomic, assign) NYT360PanningAxis allowedDeviceMotionPanningAxes;

/**
 *  Changing this property will allow you to suppress undesired range of motion along either the x or y axis for pan gesture recognizer input. For example, y axis input should probably be suppressed when a 360 video is playing inline in a scroll view.
 
 *  When this property is set, any disallowed axis will cause the current camera angles to be clamped to zero for that axis. Existing angles for the any allowed axes will not be affected.
 
 *  Defaults to NYT360PanningAxisHorizontal | NYT360PanningAxisVertical.
 */
@property (nonatomic, assign) NYT360PanningAxis allowedPanGesturePanningAxes;

@end

NS_ASSUME_NONNULL_END
