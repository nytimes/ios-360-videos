//
//  Controls.h
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//


@import Foundation;
@import UIKit;
@import SceneKit;
@import CoreMotion;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360Controls : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic) SCNNode *camera;

@property (nonatomic) UIGestureRecognizer *panRecognizer;

@property (nonatomic) SCNView *view;

@property (nonatomic) CMMotionManager *motionManager;

@property (nonatomic, assign) CGPoint rotateStart;

@property (nonatomic, assign) CGPoint rotateCurrent;

@property (nonatomic, assign) CGPoint rotateDelta;

@property (nonatomic, assign) CGPoint currentPosition;

#pragma mark - Initializers

- (id)initWithView:(SCNView *)view;

#pragma mark -

- (void)update;

@end

NS_ASSUME_NONNULL_END
