//
//  ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

@import UIKit;
@import AVFoundation;

#import "NYT360ViewController.h"

@interface ViewController : UIViewController

#pragma mark - Properties

@property (nonatomic) AVPlayer *player;
@property (nonatomic) NYT360ViewController *nyt360;

@end

