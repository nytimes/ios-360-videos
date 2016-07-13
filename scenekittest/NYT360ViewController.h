//
//  NYT360ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYT360Controls.h"

@import AVFoundation;
@import SceneKit;

@import SpriteKit;

@interface NYT360ViewController : UIViewController<SCNSceneRendererDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) SCNScene *scene;
@property (nonatomic, strong) SCNNode *videoNode;
@property (nonatomic, strong) SCNNode *cameraNode;
@property (nonatomic, strong) SCNCamera *camera;
@property (nonatomic, strong) SKScene *skScene;
@property (nonatomic, strong) SKVideoNode *skVideoNode;
@property (nonatomic, strong) NYT360Controls *controls;

- (id) initWithAVPlayer: (AVPlayer *)player;

@end
