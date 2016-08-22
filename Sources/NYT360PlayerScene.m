//
//  NYT360PlayerScene.m
//  NYT360Video
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SpriteKit;

#import "NYT360PlayerScene.h"

@class NYTSKVideoNode;

///-----------------------------------------------------------------------------
/// NYTSKVideoNodeDelegate
///-----------------------------------------------------------------------------

@protocol NYTSKVideoNodeDelegate <NSObject>

- (BOOL)videoNodeShouldAllowPlaybackToBegin:(NYTSKVideoNode *)videoNode;

@end

///-----------------------------------------------------------------------------
/// NYTSKVideoNode
///-----------------------------------------------------------------------------

/**
 *  There is a bug in SceneKit wherein a paused video node will begin playing again when the application becomes active. This is caused by cascading calls to `[fooNode setPaused:NO]` across all nodes in a scene. To prevent the video node from unpausing along with the rest of the nodes, we must subclass SKVideoNode and override `setPaused:`, only unpausing the node if `nytDelegate` allows it.
 */
@interface NYTSKVideoNode: SKVideoNode

/**
 *  The node's custom delegate. It's prefixed with `nyt_` to avoid any future conflicts with SKVideoNode properties, since this class may not be intended for subclassing.
 */
@property (nonatomic, weak) id<NYTSKVideoNodeDelegate> nyt_delegate;

@end

@implementation NYTSKVideoNode

- (void)setPaused:(BOOL)paused {
    if (!paused && self.nyt_delegate != nil) {
        if ([self.nyt_delegate videoNodeShouldAllowPlaybackToBegin:self]) {
            [super setPaused:NO];
        }
    } else {
        [super setPaused:paused];
    }
}
@end

///-----------------------------------------------------------------------------
/// NYT360PlayerScene
///-----------------------------------------------------------------------------

@interface NYT360PlayerScene () <NYTSKVideoNodeDelegate>

@property (nonatomic, assign) BOOL videoPlaybackIsPaused;
@property (nonatomic, readonly) SCNNode *cameraNode;
@property (nonatomic, readonly) NYTSKVideoNode *videoNode;

@end

@implementation NYT360PlayerScene

- (instancetype)initWithAVPlayer:(AVPlayer *)player boundToView:(SCNView *)view {
    if ((self = [super init])) {
        
        _videoPlaybackIsPaused = YES;
        
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
                NYTSKVideoNode *videoNode = [[NYTSKVideoNode alloc] initWithAVPlayer:player];
                videoNode.position = CGPointMake(scene.size.width / 2, scene.size.height / 2);
                videoNode.size = scene.size;
                videoNode.yScale = -1;
                videoNode.xScale = -1;
                videoNode.nyt_delegate = self;
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
    
    // See note in NYTSKVideoNode above.
    self.videoPlaybackIsPaused = NO;
    
    // Internally, SceneKit prefers to use `setPaused:` to toggle playback on a
    // video node. Mimic this usage here to ensure consistency and avoid putting
    // the player into an out-of-sync state.
    self.videoNode.paused = NO;
    
}

- (void)pause {
    
    // See note in NYTSKVideoNode above.
    self.videoPlaybackIsPaused = YES;
    
    // Internally, SceneKit prefers to use `setPaused:` to toggle playback on a
    // video node. Mimic this usage here to ensure consistency and avoid putting
    // the player into an out-of-sync state.
    self.videoNode.paused = YES;
    
}

- (BOOL)videoNodeShouldAllowPlaybackToBegin:(NYTSKVideoNode *)videoNode {
    // See note in NYTSKVideoNode above.
    return !self.videoPlaybackIsPaused;
}

@end
