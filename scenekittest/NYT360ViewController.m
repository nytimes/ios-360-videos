//
//  NYT360ViewController.m
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360ViewController.h"
#import "NYT360Controls.h"

@interface NYT360ViewController ()

@end

@implementation NYT360ViewController

- (id) initWithAVPlayer: (AVPlayer *)player {
    self = [super init];
    _player = player;

    return self;
}

- (void) loadView {
    // the size should also come from the user
    SCNView *view = [[SCNView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.view = view;
}

- (void) viewDidLoad {
    [super viewDidLoad];

    _videoNode = [[SCNNode alloc] init];
    _videoNode.position = SCNVector3Make(0, 0, 0);

    _camera = [[SCNCamera alloc] init];

    _camera.yFov = 100;

    _cameraNode = [[SCNNode alloc] init];
    _cameraNode.camera = _camera;

    _scene = [[SCNScene alloc] init];

    SCNView *view = (SCNView *) self.view;
    view.backgroundColor = [UIColor greenColor];
    view.delegate = self;
    view.autoenablesDefaultLighting = YES;
    _cameraNode.position = SCNVector3Make(0, 0, 0);

//    _cameraNode.eulerAngles = SCNVector3Make(-M_PI_2, 0.0, M_PI);
    [_scene.rootNode addChildNode: _cameraNode];

    view.scene = _scene;
    view.pointOfView = _cameraNode;
    view.playing = YES;

    _skScene = [[SKScene alloc] initWithSize: CGSizeMake(1280, 1280)];
    _skScene.shouldRasterize = YES;
    _skScene.scaleMode = SKSceneScaleModeAspectFit;


    _skVideoNode = [[SKVideoNode alloc] initWithAVPlayer: _player];
    _skVideoNode.position = CGPointMake(_skScene.size.width / 2, _skScene.size.height / 2);

    _skVideoNode.size = _skScene.size;
    _skVideoNode.yScale = -1;
    [_skScene addChild: _skVideoNode];

    SCNSphere *sphere = [SCNSphere sphereWithRadius:10.0];

    _videoNode.geometry = sphere;
    _videoNode.geometry.firstMaterial.diffuse.contents =
_skScene;
    _videoNode.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
    _videoNode.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
    _videoNode.geometry.firstMaterial.doubleSided = YES;

    [_scene.rootNode addChildNode: _videoNode];

    view.userInteractionEnabled = YES;
    _controls = [[NYT360Controls alloc] initWithView: view];

}

- (void)renderer:(id<SCNSceneRenderer>)renderer
  didRenderScene:(SCNScene *)scene
          atTime:(NSTimeInterval)time {
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
