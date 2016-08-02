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

        SCNNode *sphereNode = [SCNNode new];
        sphereNode.position = SCNVector3Make(0, 0, 0);
        sphereNode.geometry = [SCNSphere sphereWithRadius:100.0]; //TODO [DZ]: What is the correct size here?
        sphereNode.geometry.firstMaterial.diffuse.contents = skScene;
        sphereNode.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
        sphereNode.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
        sphereNode.geometry.firstMaterial.doubleSided = YES;

        [self.rootNode addChildNode:sphereNode];
    }

    return self;
}

- (void)bindToView:(SCNView *)view {
    view.scene = self;
    view.pointOfView = self.cameraNode;
    view.playing = YES;
}

#pragma mark - Playback

- (void)play {
    
}

- (void)pause {
    
}

@end
