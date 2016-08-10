//
//  NYT360ViewController.h
//  NYT360Video
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;
@import AVFoundation;

#import "NYT360MotionManagement.h"
#import "NYT360DataTypes.h"

@class NYT360CameraPanGestureRecognizer;
@class NYT360CameraController;

CGRect NYT360ViewControllerSceneFrameForContainingBounds(CGRect containingBounds, CGSize underlyingSceneSize);
CGRect NYT360ViewControllerSceneBoundsForScreenBounds(CGRect screenBounds);

NS_ASSUME_NONNULL_BEGIN

@protocol NYT360ViewControllerDelegate <NSObject>

/**
 *  Called when the camera angle was updated.
 *
 *  @param cameraController The camera controller that updated the angle.
 */
- (void)cameraAngleWasUpdated:(NYT360CameraController *)cameraController;

@end

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

/**
 *  The delegate of the view controller.
 */
@property (nullable, nonatomic, weak) id <NYT360ViewControllerDelegate> delegate;

#pragma mark - Initializers

- (id)initWithAVPlayer:(AVPlayer *)player motionManager:(id<NYT360MotionManagement>)motionManager;

#pragma mark - Playback

- (void)play;
- (void)pause;

#pragma mark - Camera Movement

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
