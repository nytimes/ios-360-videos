//
//  NYT360ViewController.h
//  scenekittest
//
//  Created by Thiago on 7/12/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;
@import SceneKit;
@import AVFoundation;

#import "NYTMotionManagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

#pragma mark - Initializers

- (id)initWithAVPlayer:(AVPlayer *)player motionManager:(id<NYTMotionManagement>)motionManager;

@end

NS_ASSUME_NONNULL_END
