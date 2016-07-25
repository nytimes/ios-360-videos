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

@interface NYT360ViewController ()

@property (nonatomic) NYT360PlayerScene *playerScene;
@property (nonatomic) NYT360CameraController *cameraController;

@end

@implementation NYT360ViewController

- (id)initWithAVPlayer:(AVPlayer *)player {
    self = [super init];
    if (self) {
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
    
    SCNView *view = (SCNView *)self.view;
    view.backgroundColor = [UIColor greenColor];
    view.delegate = self;
    
    [self.playerScene bindToView:view];
    
    self.cameraController = [[NYT360CameraController alloc] initWithView:view];
    [self adjustCameraFOV];
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
