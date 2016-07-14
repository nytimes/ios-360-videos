//
//  Controls.m
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360Controls.h"

#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

CGPoint subtractPoints(CGPoint a, CGPoint b) {
    return CGPointMake(b.x - a.x, b.y - a.y);
}

@interface NYT360Controls ()

@property (nonatomic) SCNView *view;
@property (nonatomic) UIGestureRecognizer *panRecognizer;
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) SCNNode *camera;

@property (nonatomic, assign) CGPoint rotateStart;
@property (nonatomic, assign) CGPoint rotateCurrent;
@property (nonatomic, assign) CGPoint rotateDelta;
@property (nonatomic, assign) CGPoint currentPosition;

@end

@implementation NYT360Controls

- (id)initWithView:(SCNView *)view {
    self = [super init];
    if (self) {
        _camera = view.pointOfView;
        _view = view;
        _currentPosition = CGPointMake(0, 0);
        
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panRecognizer.delegate = self;
        [_view addGestureRecognizer:_panRecognizer];
        
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 0.01;
        [_motionManager startDeviceMotionUpdates];
    }
    
    return self;
}

- (void)update {
    CMRotationRate rotationRate = self.motionManager.deviceMotion.rotationRate;
    CGPoint position = CGPointMake(self.currentPosition.x + rotationRate.y * 0.02,
                                   self.currentPosition.y - rotationRate.x * 0.02 * -1);
    position.y = CLAMP(self.currentPosition.y, -M_PI / 2, M_PI / 2);
    self.currentPosition = position;
    
    self.camera.eulerAngles = SCNVector3Make(self.currentPosition.y, self.currentPosition.x, 0);
}

- (void)handlePan:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.rotateStart = point;
            break;
        case UIGestureRecognizerStateChanged:
            self.rotateCurrent = point;
            self.rotateDelta = subtractPoints(self.rotateStart, self.rotateCurrent);
            self.rotateStart = self.rotateCurrent;
        
            CGPoint position = CGPointMake(self.currentPosition.x + 2 * M_PI * self.rotateDelta.x / self.view.frame.size.width * 0.5,
                                           self.currentPosition.y + 2 * M_PI * self.rotateDelta.y / self.view.frame.size.height * 0.4);
            position.y = CLAMP(self.currentPosition.y, -M_PI / 2, M_PI / 2);
            self.currentPosition = position;
        
            self.camera.eulerAngles = SCNVector3Make(self.currentPosition.y, self.currentPosition.x, 0);
            break;
        default:
            break;
    }
}

@end
