//
//  NYT360ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;

@class AVPlayer;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

#pragma mark - Initializers

- (instancetype)initWithAVPlayer:(AVPlayer *)player;

#pragma mark - Playback

- (void)play;
- (void)pause;

@end

NS_ASSUME_NONNULL_END
