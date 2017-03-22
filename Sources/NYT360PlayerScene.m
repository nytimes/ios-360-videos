//
//  NYT360PlayerScene.m
//  NYT360Video
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SpriteKit;
@import AVFoundation;

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
 *
 *  This SceneKit bug is present on iOS 9 as well as iOS 10 (at least up to beta 7, the latest at the time of this writing).
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
@property (nonatomic, readonly) AVPlayer *player;

@end

@implementation NYT360PlayerScene

- (instancetype)initWithAVPlayer:(AVPlayer *)player boundToView:(SCNView *)view {
    if ((self = [super init])) {
        
        _videoPlaybackIsPaused = YES;
        
        _player = player;
        
        _camera = [SCNCamera new];
        
        _cameraNode = ({
            SCNNode *cameraNode = [SCNNode new];
            cameraNode.camera = _camera;
            cameraNode.position = SCNVector3Make(0, 0, 0);
            cameraNode;
        });
        [self.rootNode addChildNode:_cameraNode];
        
        SKScene *skScene = ({
			AVAssetTrack *assetTrack = [[player.currentItem.asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
			CGSize assetDimensions = assetTrack ? CGSizeApplyAffineTransform(assetTrack.naturalSize, assetTrack.preferredTransform) : CGSizeMake(1280, 1280);
			SKScene *scene = [[SKScene alloc] initWithSize:CGSizeMake(fabsf(assetDimensions.width), fabsf(assetDimensions.height))];
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
    
    if ([self.class isIOS10OrLater]) {
        // On iOS 10, AVPlayer playback on a video node seems to work most
        // reliably by directly invoking `play` and `pause` on the player,
        // rather than the alternatives: calling the `play` and `pause` methods
        // or the `setPaused:` setter on the video node. Those alternatives
        // either do not work at all in certain cases, or they lead to spurious
        // rate changes on the AVPlayer, which fire KVO notifications that
        // NYTVideoViewController is not designed to handle. In an ideal world,
        // we could refactor NYTVideoViewController to handle such edge cases.
        // In practice, it is preferable to use the following technique so that
        // 360 AVPlayer behavior on iOS 10 is the same as on iOS 9, and the same
        // as standard AVPlayer behavior on both operating systems.
        [self.player play];
        // On iOS 10, you must also update the `paused` property of the video
        // node to match the playback state of its AVPlayer if you have invoked
        // play/pause directly on the AVPlayer, otherwise the video node's
        // internal state and the AVPlayer's timeControlStatus can get out of
        // sync. One symptom of this problem is where the video can look like
        // it's paused even though the audio is still playing in the background.
        // The steps to reproduce this particular bug are finicky but reliable.
        self.videoNode.paused = NO;
    }
    else {
        // Prior to iOS 10, SceneKit prefers to use `setPaused:` alone to toggle
        // playback on a video node. Mimic this usage here to ensure consistency
        // and avoid putting the player into an out-of-sync state.
        self.videoNode.paused = NO;
    }
    
}

- (void)pause {
    
    // See note in NYTSKVideoNode above.
    self.videoPlaybackIsPaused = YES;
    
    if ([self.class isIOS10OrLater]) {
        // On iOS 10, AVPlayer playback on a video node seems to work most
        // reliably by directly invoking `play` and `pause` on the player,
        // rather than the alternatives: calling the `play` and `pause` methods
        // or the `setPaused:` setter on the video node. Those alternatives
        // either do not work at all in certain cases, or they lead to spurious
        // rate changes on the AVPlayer, which fire KVO notifications that
        // NYTVideoViewController is not designed to handle. In an ideal world,
        // we could refactor NYTVideoViewController to handle such edge cases.
        // In practice, it is preferable to use the following technique so that
        // 360 AVPlayer behavior on iOS 10 is the same as on iOS 9, and the same
        // as standard AVPlayer behavior on both operating systems.
        [self.player pause];
        // On iOS 10, you must also update the `paused` property of the video
        // node to match the playback state of its AVPlayer if you have invoked
        // play/pause directly on the AVPlayer, otherwise the video node's
        // internal state and the AVPlayer's timeControlStatus can get out of
        // sync. One symptom of this problem is where the video can look like
        // it's paused even though the audio is still playing in the background.
        // The steps to reproduce this particular bug are finicky but reliable.
        self.videoNode.paused = YES;
    }
    else {
        // Prior to iOS 10, SceneKit prefers to use `setPaused:` alone to toggle
        // playback on a video node. Mimic this usage here to ensure consistency
        // and avoid putting the player into an out-of-sync state. There is one
        // caveat, however: when the host application is pausing playback as the
        // app is entering the background (and if background audio is enabled in
        // the host application), then if you do not also call `pause` directly
        // on the AVPlayer, then the player's audio will continue playing in the
        // background. Even though this bug workaround means that our `pause`
        // implementation is identical between iOS 8/9 and iOS 10, it's worth
        // keeping the above check for the OS version since the edge cases
        // before and after iOS 10 are different enough that it's worth keeping
        // the implementations separated, if only for clarity that can be added
        // via OS specific documentation (and also the fact that iOS 10's
        // behavior may change between the current beta and a future production
        // release).
        [self.player pause];
        self.videoNode.paused = YES;
    }
    
}

#pragma mark - NYTSKVideoNodeDelegate

- (BOOL)videoNodeShouldAllowPlaybackToBegin:(NYTSKVideoNode *)videoNode {
    // See note in NYTSKVideoNode above.
    return !self.videoPlaybackIsPaused;
}

#pragma mark - Convenience

+ (BOOL)isIOS10OrLater {
    static BOOL isIOS10OrLater;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSOperatingSystemVersion ios10;
        ios10.majorVersion = 10;
        ios10.minorVersion = 0;
        ios10.patchVersion = 0;

        isIOS10OrLater = [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios10];
    });

    return isIOS10OrLater;
}

@end
