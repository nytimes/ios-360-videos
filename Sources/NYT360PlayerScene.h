//
//  NYT360PlayerScene.h
//  scenekittest
//
//  Created by Chris Dzombak on 7/14/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@import SceneKit;

@interface NYT360PlayerScene : SCNScene

@property (nonatomic, readonly) SCNCamera *camera;

- (instancetype)initWithAVPlayer:(AVPlayer *)player;

- (void)bindToView:(SCNView *)view;

@end

NS_ASSUME_NONNULL_END
