//
//  NYT360ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//


@import AVFoundation;
@import SceneKit;
@import UIKit;
@import SpriteKit;

#import "NYT360Controls.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

#pragma mark - Properties

@property (nonatomic) AVPlayer *player;
@property (nonatomic) SCNScene *scene;
@property (nonatomic) SCNNode *videoNode;
@property (nonatomic) SCNNode *cameraNode;
@property (nonatomic) SCNCamera *camera;
@property (nonatomic) SKScene *skScene;
@property (nonatomic) SKVideoNode *skVideoNode;
@property (nonatomic) NYT360Controls *controls;

#pragma mark - Initializers

- (id)initWithAVPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
