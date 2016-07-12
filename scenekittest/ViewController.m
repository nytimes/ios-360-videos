//
//  ViewController.m
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "ViewController.h"
#import "NYT360.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *videoURL = [[NSURL alloc] initWithString:@"https://vp.nyt.com/video/2016/04/01/39069_1_fb-360-coney-island_wg_720p.mp4"];
    
    self.player = [[AVPlayer alloc] initWithURL: videoURL];
    AVPlayerLayer *layer = [[AVPlayerLayer alloc] init];
    layer.frame = CGRectMake(30, 30, 500, 500);
    layer.player = self.player;
    
    [self.player play];
    
    [self.view.layer addSublayer:layer];
    self.nyt360 = [[NYT360 alloc] initWithAVPlayer: self.player];
    
    [self.view addSubview: _nyt360];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
