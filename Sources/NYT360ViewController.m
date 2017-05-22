//
//  NYT360ViewController.m
//  NYT360Video
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360ViewController.h"
#import "NYT360CameraController.h"
#import "NYT360PlayerScene.h"

CGRect NYT360ViewControllerSceneFrameForContainingBounds(CGRect containingBounds, CGSize underlyingSceneSize) {
    
    if (CGSizeEqualToSize(underlyingSceneSize, CGSizeZero)) {
        return containingBounds;
    }
    
    CGSize containingSize = containingBounds.size;
    CGFloat heightRatio = containingSize.height / underlyingSceneSize.height;
    CGFloat widthRatio = containingSize.width / underlyingSceneSize.width;
    CGSize targetSize;
    if (heightRatio > widthRatio) {
        targetSize = CGSizeMake(underlyingSceneSize.width * heightRatio, underlyingSceneSize.height * heightRatio);
    } else {
        targetSize = CGSizeMake(underlyingSceneSize.width * widthRatio, underlyingSceneSize.height * widthRatio);
    }
    
    CGRect targetFrame = CGRectZero;
    targetFrame.size = targetSize;
    targetFrame.origin.x = (containingBounds.size.width - targetSize.width) / 2.0;
    targetFrame.origin.y = (containingBounds.size.height - targetSize.height) / 2.0;
    
    return targetFrame;
}

CGRect NYT360ViewControllerSceneBoundsForScreenBounds(CGRect screenBounds) {
    CGFloat max = MAX(screenBounds.size.width, screenBounds.size.height);
    CGFloat min = MIN(screenBounds.size.width, screenBounds.size.height);
    return CGRectMake(0, 0, max, min);
}

@interface NYT360ViewController () <NYT360CameraControllerDelegate>

@property (nonatomic, readonly) CGSize underlyingSceneSize;
@property (nonatomic, readonly) SCNView *sceneView;
@property (nonatomic, readonly) NYT360PlayerScene *playerScene;
@property (nonatomic, readonly) NYT360CameraController *cameraController;

@end

@implementation NYT360ViewController

#pragma mark - Init

- (instancetype)initWithAVPlayer:(AVPlayer *)player motionManager:(id<NYT360MotionManagement>)motionManager {
    self = [super init];
    if (self) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect initialSceneFrame = NYT360ViewControllerSceneBoundsForScreenBounds(screenBounds);
        _underlyingSceneSize = initialSceneFrame.size;
        _sceneView = [[SCNView alloc] initWithFrame:initialSceneFrame];
        _playerScene = [[NYT360PlayerScene alloc] initWithAVPlayer:player boundToView:_sceneView];
        _cameraController = [[NYT360CameraController alloc] initWithView:_sceneView motionManager:motionManager];
        _cameraController.delegate = self;

        typeof(self) __weak weakSelf = self;
        _cameraController.compassAngleUpdateBlock = ^(float compassAngle) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }

            [strongSelf.delegate nyt360ViewController:strongSelf didUpdateCompassAngle:strongSelf.compassAngle];
        };

    }
    return self;
}

- (void)dealloc {
    _sceneView.delegate = nil;
}

#pragma mark - Playback

- (void)play {
    [self.playerScene play];
}

- (void)pause {
    [self.playerScene pause];
}

#pragma mark - Camera Movement

- (float)compassAngle {
    return self.cameraController.compassAngle;
}

- (NYT360CameraPanGestureRecognizer *)panRecognizer {
    return self.cameraController.panRecognizer;
}

- (NYT360PanningAxis)allowedDeviceMotionPanningAxes {
    return self.cameraController.allowedDeviceMotionPanningAxes;
}

- (void)setAllowedDeviceMotionPanningAxes:(NYT360PanningAxis)allowedDeviceMotionPanningAxes {
    self.cameraController.allowedDeviceMotionPanningAxes = allowedDeviceMotionPanningAxes;
}

- (NYT360PanningAxis)allowedPanGesturePanningAxes {
    return self.cameraController.allowedPanGesturePanningAxes;
}

- (void)setAllowedPanGesturePanningAxes:(NYT360PanningAxis)allowedPanGesturePanningAxes {
    self.cameraController.allowedPanGesturePanningAxes = allowedPanGesturePanningAxes;
}

- (void)reorientVerticalCameraAngleToHorizon:(BOOL)animated {
    [self.cameraController reorientVerticalCameraAngleToHorizon:animated];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.opaque = YES;
    
    // Prevent the edges of the "aspect-fill" resized player scene from being
    // visible beyond the bounds of `self.view`.
    self.view.clipsToBounds = YES;
    
    // self.sceneView.showsStatistics = YES;
    self.sceneView.autoresizingMask = UIViewAutoresizingNone;
    self.sceneView.backgroundColor = [UIColor blackColor];
    self.sceneView.opaque = YES;
    self.sceneView.delegate = self;
    [self.view addSubview:self.sceneView];
        
    self.sceneView.playing = true;
    
    [self.cameraController updateCameraFOV:self.view.bounds.size];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // We cannot change the aspect ratio of the scene view without introducing
    // visual distortions. Instead, we must preserve the (arbitrary) underlying
    // aspect ratio and resize the scene view to fill the bounds of `self.view`.
    self.sceneView.frame = NYT360ViewControllerSceneFrameForContainingBounds(self.view.bounds, self.underlyingSceneSize);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.cameraController startMotionUpdates];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.cameraController stopMotionUpdates];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // The goal below is to avoid a jarring change of the .yFov property of the
    // camera node. Luckily, that property is animatable. While it isn't strictly
    // necessary to call `adjustCameraFOV` from within the UIKit animation block,
    // it does make the logic here more readable. It also means we can reset the
    // transaction animation duration back to 0 at the end of the transition by
    // using the coordinator method's completion block argument.
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [SCNTransaction setAnimationDuration:coordinator.transitionDuration];
        [self.cameraController updateCameraFOV:size];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (!context.isCancelled) {
            // If you don't reset the duration to 0, all future camera upates
            // coming from device motion or manual panning will be applied with
            // the non-zero transaction duration, making the camera updates feel
            // sluggish.
            [SCNTransaction setAnimationDuration:0];
        }
    }];
}

#pragma mark - SCNSceneRendererDelegate

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    [self.cameraController updateCameraAngleForCurrentDeviceMotion];
}

#pragma mark - NYT360CameraControllerDelegate

- (void)cameraController:(NYT360CameraController *)controller userInitallyMovedCameraViaMethod:(NYT360UserInteractionMethod)method {
    [self.delegate videoViewController:self userInitallyMovedCameraViaMethod:method];
}

@end
