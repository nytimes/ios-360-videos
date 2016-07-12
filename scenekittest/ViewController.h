//
//  ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYT360.h"

@import AVFoundation;

@interface ViewController : UIViewController

@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic, strong) NYT360 *nyt360;
@end

