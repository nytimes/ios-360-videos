//
//  NYT360ViewController.m
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import AVFoundation;

#import "NYT360ViewController.h"
#import "NYT360CameraController.h"
#import "NYT360PlayerScene.h"

static inline CGRect NYT360ViewControllerSceneFrameForContainingBounds(CGRect containingBounds, CGSize underlyingSceneSize) {
    
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

static inline CGRect NYT360ViewControllerSceneBoundsForScreenBounds(CGRect screenBounds) {
    CGFloat max = MAX(screenBounds.size.width, screenBounds.size.height);
    CGFloat min = MIN(screenBounds.size.width, screenBounds.size.height);
    return CGRectMake(0, 0, max, min);
}

@interface NYT360ViewController ()

@property (nonatomic, readonly) CGSize underlyingSceneSize;
@property (nonatomic, readonly) SCNView *sceneView;
@property (nonatomic, readonly) NYT360PlayerScene *playerScene;
@property (nonatomic, readonly) NYT360CameraController *cameraController;

@end

@implementation NYT360ViewController

- (instancetype)initWithAVPlayer:(AVPlayer *)player {
    self = [super init];
    if (self) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        CGRect initialSceneFrame = NYT360ViewControllerSceneBoundsForScreenBounds(screenBounds);
        _underlyingSceneSize = initialSceneFrame.size;
        _sceneView = [[SCNView alloc] initWithFrame:initialSceneFrame];
        _cameraController = [[NYT360CameraController alloc] initWithView:_sceneView];
        _playerScene = [[NYT360PlayerScene alloc] initWithAVPlayer:player];
    }
    return self;
}

- (void)loadView {
    // the size should also come from the user
    SCNView *view = [[SCNView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.showsStatistics = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.view.opaque = YES;
    
    // self.sceneView.showsStatistics = YES;
    self.sceneView.autoresizingMask = UIViewAutoresizingNone;
    self.sceneView.backgroundColor = [UIColor blackColor];
    self.sceneView.opaque = YES;
    self.sceneView.delegate = self;
    [self.view addSubview:self.sceneView];
    
    [self.playerScene bindToView:self.sceneView];
    
    [self adjustCameraFOV];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
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

- (void)renderer:(id <SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time {
    [self.cameraController updateCameraAngle];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self adjustCameraFOV];
}

- (void)adjustCameraFOV {
    // TODO [DZ]: What are the correct values here?
    if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || [UIDevice currentDevice].orientation == UIInterfaceOrientationUnknown) {
        self.playerScene.camera.yFov = 100;
    }
    else {
        self.playerScene.camera.yFov = 60;
    }
}

@end
