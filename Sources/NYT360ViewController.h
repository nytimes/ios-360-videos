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

#import "NYT360MotionManagement.h"

CGRect NYT360ViewControllerSceneFrameForContainingBounds(CGRect containingBounds, CGSize underlyingSceneSize);
CGRect NYT360ViewControllerSceneBoundsForScreenBounds(CGRect screenBounds);

NS_ASSUME_NONNULL_BEGIN

@interface NYT360ViewController : UIViewController <SCNSceneRendererDelegate>

#pragma mark - Initializers

- (id)initWithAVPlayer:(AVPlayer *)player motionManager:(id<NYT360MotionManagement>)motionManager;

@end

NS_ASSUME_NONNULL_END
