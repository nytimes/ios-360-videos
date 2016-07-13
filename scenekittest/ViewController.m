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

    self.player = [[AVPlayer alloc] initWithURL: videoURL];

    self.nyt360 = [[NYT360ViewController alloc] initWithAVPlayer: self.player];
    
    [self.view addSubview: _nyt360.view];
    [_player play];

}

- (void)slide: (UISlider *) sender {
    _nyt360.cameraNode.position = SCNVector3Make(0, 0, (1 - sender.value) * 20);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
