//
//  NYT360PlayerScene.m
//  NYT360Video
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SpriteKit;

#import "NYT360PlayerScene.h"

@interface NYT360PlayerScene ()

@property (nonatomic, readonly) SCNNode *cameraNode;
@property (nonatomic, readonly) SKVideoNode *videoNode;

@end

@implementation NYT360PlayerScene

- (instancetype)initWithAVPlayer:(AVPlayer *)player boundToView:(SCNView *)view {
    if ((self = [super init])) {
        
        _camera = [SCNCamera new];

        _cameraNode = ({
            SCNNode *cameraNode = [SCNNode new];
            cameraNode.camera = _camera;
            cameraNode.position = SCNVector3Make(0, 0, 0);
            cameraNode;
        });
        [self.rootNode addChildNode:_cameraNode];

        SKScene *skScene = ({
            SKScene *scene = [[SKScene alloc] initWithSize:CGSizeMake(1280, 1280)];
            scene.shouldRasterize = YES;
            scene.scaleMode = SKSceneScaleModeAspectFit;
            _videoNode = ({
                SKVideoNode *videoNode = [[SKVideoNode alloc] initWithAVPlayer:player];
                videoNode.position = CGPointMake(scene.size.width / 2, scene.size.height / 2);
                videoNode.size = scene.size;
                videoNode.yScale = -1;
                videoNode.xScale = -1;
                videoNode;
            });
            [scene addChild:_videoNode];
            scene;
        });

        SCNNode *sphereNode = ({
            SCNNode *sphereNode = [SCNNode new];
            sphereNode.position = SCNVector3Make(0, 0, 0);
            sphereNode.geometry = [SCNSphere sphereWithRadius:100.0]; //TODO [DZ]: What is the correct size here?
            sphereNode.geometry.firstMaterial.diffuse.contents = skScene;
            sphereNode.geometry.firstMaterial.diffuse.minificationFilter = SCNFilterModeLinear;
            sphereNode.geometry.firstMaterial.diffuse.magnificationFilter = SCNFilterModeLinear;
            sphereNode.geometry.firstMaterial.doubleSided = YES;
            sphereNode;
        });
        [self.rootNode addChildNode:sphereNode];
        
        view.scene = self;
        view.pointOfView = self.cameraNode;
    }

    return self;
}

#pragma mark - Playback

- (void)play {
    [self.videoNode play];
}

- (void)pause {
    [self.videoNode pause];
}

@end
