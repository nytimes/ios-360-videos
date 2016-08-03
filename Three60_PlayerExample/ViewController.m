//
//  ViewController.m
//  Three60_PlayerExample
//
//  Created by Chris Dzombak on 7/25/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import AVFoundation;
@import Three60_Player;

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) NYT360ViewController *nyt360VC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSURL *videoURL = [[NSURL alloc] initWithString:@"https://vp.nyt.com/video/360/hls/video.m3u8"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];

    self.view.backgroundColor = [UIColor blackColor];
    NYT360MotionManager *manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player motionManager:manager];

    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];

    [self.player play];
}

@end
