//
//  Controls.m
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//


#import "NYT360Controls.h"
#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

@implementation NYT360Controls

- (id) initWithView: (SCNView *) view {
    self = [super init];
    _camera = view.pointOfView;
    _view = view;
    _currentPosition = CGPointMake(0, 0);

    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _panRecognizer.delegate = self;
    [_view addGestureRecognizer:_panRecognizer];

    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 0.01;
    [_motionManager startDeviceMotionUpdates];

    return self;
}

-(void)update {
    CMRotationRate rotationRate = _motionManager.deviceMotion.rotationRate;
    _currentPosition = CGPointMake(_currentPosition.x + rotationRate.y * 0.02,
                                   _currentPosition.y - rotationRate.x * 0.02 * -1);
    _currentPosition.y = CLAMP(_currentPosition.y, -M_PI / 2 , M_PI / 2);
    _camera.eulerAngles = SCNVector3Make(_currentPosition.y, _currentPosition.x, 0);
}

- (void) handlePan: (UIPanGestureRecognizer *) sender {
    CGPoint point = [sender locationInView: _view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            _rotateStart = point;
            break;
        case UIGestureRecognizerStateChanged:
            _rotateCurrent = point;
            _rotateDelta = subtractPoints(_rotateStart, _rotateCurrent);
            _rotateStart = _rotateCurrent;
            _currentPosition = CGPointMake(_currentPosition.x + 2 * M_PI * _rotateDelta.x / _view.frame.size.width * 0.5,
                                           _currentPosition.y + 2 * M_PI * _rotateDelta.y / _view.frame.size.height * 0.4);
            _currentPosition.y = CLAMP(_currentPosition.y, -M_PI / 2 , M_PI / 2);
            _camera.eulerAngles = SCNVector3Make(_currentPosition.y, _currentPosition.x, 0);
            break;
        default:
            break;
    }
}


CGPoint subtractPoints(CGPoint a, CGPoint b) {
    return CGPointMake(b.x - a.x, b.y - a.y);
}

@end
