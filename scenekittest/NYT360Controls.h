//
//  Controls.h
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import <Foundation/Foundation.h>



@import UIKit;
@import SceneKit;
@import CoreMotion;

@interface NYT360Controls : NSObject<UIGestureRecognizerDelegate>
@property (nonatomic, strong) SCNNode *camera;
@property (nonatomic, strong) UIGestureRecognizer* panRecognizer;
@property (nonatomic, strong) SCNView *view;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property CGPoint rotateStart;
@property CGPoint rotateCurrent;
@property CGPoint rotateDelta;
@property CGPoint currentPosition;

- (id) initWithView: (SCNView *) view;

@end
