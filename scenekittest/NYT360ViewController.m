//
//  NYT360ViewController.m
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360ViewController.h"
#import "NYT360CameraController.h"

@interface NYT360ViewController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) SCNScene *scene;
@property (nonatomic) SCNNode *videoNode;
@property (nonatomic) SCNNode *cameraNode;
@property (nonatomic) SCNCamera *camera;
@property (nonatomic) SKScene *skScene;
@property (nonatomic) SKVideoNode *skVideoNode;
@property (nonatomic) NYT360CameraController *cameraController;

@end

@implementation NYT360ViewController

- (id)initWithAVPlayer:(AVPlayer *)player {
    self = [super init];
    if (self) {
        _player = player;
        
        _camera = [[SCNCamera alloc] init];
        
        _cameraNode = [[SCNNode alloc] init];
        _cameraNode.camera = _camera;
        _cameraNode.position = SCNVector3Make(0, 0, 0);
        
        _scene = [[SCNScene alloc] init];
        [_scene.rootNode addChildNode:_cameraNode];
        
        _skScene = [[SKScene alloc] initWithSize:CGSizeMake(1280, 1280)];
        _skScene.shouldRasterize = YES;
        _skScene.scaleMode = SKSceneScaleModeAspectFit;
        
        _skVideoNode = [[SKVideoNode alloc] initWithAVPlayer:_player];
        _skVideoNode.position = CGPointMake(_skScene.size.width / 2, _skScene.size.height / 2);
        _skVideoNode.size = _skScene.size;
        _skVideoNode.yScale = -1;
        _skVideoNode.xScale = -1;
        [_skScene addChild:_skVideoNode];
        
        _videoNode = [[SCNNode alloc] init];
        _videoNode.position = SCNVector3Make(0, 0, 0);
        _videoNode.geometry = [SCNSphere sphereWithRadius:100.0]; //TODO [DZ]: What is the correct size here?
        _videoNode.geometry.firstMaterial.diffuse.contents = _skScene;
        _videoNode.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
        _videoNode.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
        _videoNode.geometry.firstMaterial.doubleSided = YES;
        [_scene.rootNode addChildNode:_videoNode];
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
    
    view.scene = self.scene;
    view.pointOfView = self.cameraNode;
    view.playing = YES;
    
    self.cameraController = [[NYT360CameraController alloc] initWithView:view];
    [self adjustCameraFOV];
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
        self.camera.yFov = 100;
    }
    else {
        self.camera.yFov = 60;
    }
}

@end
