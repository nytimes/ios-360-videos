//
//  ViewController.m
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "ViewController.h"
#import "NYT360ViewController.h"

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
    self.nyt360VC = [[NYT360ViewController alloc] initWithAVPlayer:self.player];

    [self addChildViewController:self.nyt360VC];
    [self.view addSubview:self.nyt360VC.view];
    [self.nyt360VC didMoveToParentViewController:self];
    
    [self.player play];
}

@end
