//
//  NYT360.h
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@import AVFoundation;
@import SceneKit;
@import GLKit;

@interface NYT360 : SCNView<SCNSceneRendererDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItemVideoOutput *videoOutput;
@property (nonatomic, strong) SCNNode *node;



- (id) initWithAVPlayer: (AVPlayer *)player;
- (void) drawVideo;

@end
