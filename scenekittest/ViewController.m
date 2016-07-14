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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *videoURL = [[NSURL alloc] initWithString:@"https://vp.nyt.com/video/360/hls/video.m3u8"];
    self.player = [[AVPlayer alloc] initWithURL:videoURL];
    
    self.nyt360 = [[NYT360ViewController alloc] initWithAVPlayer:self.player];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.nyt360.view];
    [self addChildViewController:self.nyt360];
    
    [self.player play];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

@end
