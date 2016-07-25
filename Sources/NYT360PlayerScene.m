//
//  NYT360PlayerScene.m
//  scenekittest
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SpriteKit;

#import "NYT360PlayerScene.h"

@interface NYT360PlayerScene ()

@property (nonatomic, readonly) SCNNode *cameraNode;

@end

@implementation NYT360PlayerScene

- (instancetype)initWithAVPlayer:(AVPlayer *)player {
    if ((self = [super init])) {
        _camera = [SCNCamera new];

        _cameraNode = [SCNNode new];
        _cameraNode.camera = _camera;
        _cameraNode.position = SCNVector3Make(0, 0, 0);

        [self.rootNode addChildNode:_cameraNode];

        SKScene *skScene = ({
            SKScene *scene = [[SKScene alloc] initWithSize:CGSizeMake(1280, 1280)];
            scene.shouldRasterize = YES;
            scene.scaleMode = SKSceneScaleModeAspectFit;

            SKVideoNode *skVideoNode = [[SKVideoNode alloc] initWithAVPlayer:player];
            skVideoNode.position = CGPointMake(scene.size.width / 2, scene.size.height / 2);
            skVideoNode.size = scene.size;
            skVideoNode.yScale = -1;
            skVideoNode.xScale = -1;

            [scene addChild:skVideoNode];
            scene;
        });

        SCNNode *videoNode = [SCNNode new];
        videoNode.position = SCNVector3Make(0, 0, 0);
        videoNode.geometry = [SCNSphere sphereWithRadius:100.0]; //TODO [DZ]: What is the correct size here?
        videoNode.geometry.firstMaterial.diffuse.contents = skScene;
        videoNode.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
        videoNode.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
        videoNode.geometry.firstMaterial.doubleSided = YES;

        [self.rootNode addChildNode:videoNode];
    }

    return self;
}

- (void)bindToView:(SCNView *)view {
    view.scene = self;
    view.pointOfView = self.cameraNode;
    view.playing = YES;
}

@end
