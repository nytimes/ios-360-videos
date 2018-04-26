//
//  ViewController.m
//  NYT360VideoExample
//
//  Created by Chris Dzombak on 7/25/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import AVFoundation;
@import NYT360Video;

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) AVPlayer *player;
@property (nonatomic) NYT360ViewController *nyt360VC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    // Create an AVPlayer for a 360º video:
    NSURL * const videoURL = [[NSURL alloc] initWithString:@"https://vp.nyt.com/video/hls/2017/12/07/74928_1_360-AMNH_wg/master.m3u8"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];

    // Create a NYT360ViewController with the AVPlayer and our app's motion manager:
    id<NYT360MotionManagement> const manager = [NYT360MotionManager sharedManager];
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player motionManager:manager];

    // Embed the player view controller in our UI, via view controller containment:
    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];

    // Begin playing the 360º video:
    [self.player play];

    // In this example, tapping the video will place the horizon in the middle of the screen:
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reorientVerticalCameraAngle:)];
    [self.view addGestureRecognizer:tapRecognizer];
}

- (void)reorientVerticalCameraAngle:(id)sender {
    [self.nyt360VC reorientVerticalCameraAngleToHorizon:YES];
}

@end
