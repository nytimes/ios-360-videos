//
//  NYT360PlayerScene.h
//  NYT360Video
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@import SceneKit;

/**
 A 3D video playback scene.
 */
@interface NYT360PlayerScene : SCNScene

@property (nonatomic, readonly) SCNCamera *camera;

- (instancetype)initWithAVPlayer:(AVPlayer *)player boundToView:(SCNView *)view;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
