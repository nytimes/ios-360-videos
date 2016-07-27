//
//  NYT360CameraController.m
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import SceneKit;
@import CoreMotion;

#import "NYT360CameraController.h"

#define CLAMP(x, low, high) (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

CGPoint subtractPoints(CGPoint a, CGPoint b) {
    return CGPointMake(b.x - a.x, b.y - a.y);
}

@interface NYT360CameraController ()

@property (nonatomic) SCNView *view;
@property (nonatomic) UIGestureRecognizer *panRecognizer;
@property (nonatomic) CMMotionManager *motionManager;
@property (nonatomic) SCNNode *camera;

@property (nonatomic, assign) CGPoint rotateStart;
@property (nonatomic, assign) CGPoint rotateCurrent;
@property (nonatomic, assign) CGPoint rotateDelta;
@property (nonatomic, assign) CGPoint currentPosition;

@end

@implementation NYT360CameraController

- (id)initWithView:(SCNView *)view {
    self = [super init];
    if (self) {
        _camera = view.pointOfView;
        _view = view;
        _currentPosition = CGPointMake(0, 0);
        _allowedPanningAxes = NYT360PanningAxisHorizontal & NYT360PanningAxisVertical;
        
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panRecognizer.delegate = self;
        [_view addGestureRecognizer:_panRecognizer];
        
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = (1.f / 60.f);
    }
    
    return self;
}

- (void)startMotionUpdates {
    [self.motionManager startDeviceMotionUpdates];
}

- (void)stopMotionUpdates {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)updateCameraAngle {
#ifdef DEBUG
    if (!self.motionManager.deviceMotionActive) {
        NSLog(@"Warning: %@ called while %@ is not receiving motion updates", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    }
#endif
    
    CMRotationRate rotationRate = self.motionManager.deviceMotion.rotationRate;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    // TODO: [jaredsinclair] Clamp x/y components to 0 if the relevant axis is not
    // included in `allowedPanningAxes`.
    
    // TODO: [thiago] I think this can be simplified later
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            self.currentPosition = CGPointMake(self.currentPosition.x + rotationRate.x * 0.02 * -1,
                                               self.currentPosition.y + rotationRate.y * 0.02);
        }
        else {
            self.currentPosition = CGPointMake(self.currentPosition.x + rotationRate.x * 0.02,
                                               self.currentPosition.y + rotationRate.y * 0.02 * -1);
        }
    }
    else {
        self.currentPosition = CGPointMake(self.currentPosition.x + rotationRate.y * 0.02,
                                           self.currentPosition.y - rotationRate.x * 0.02 * -1);
    }
    self.currentPosition = CGPointMake(self.currentPosition.x,
                                       CLAMP(self.currentPosition.y, -M_PI / 2, M_PI / 2));
    
    self.camera.eulerAngles = SCNVector3Make(self.currentPosition.y, self.currentPosition.x, 0);
}

- (void)setAllowedPanningAxes:(NYT360PanningAxis)allowedPanningAxes {
    _allowedPanningAxes = allowedPanningAxes;
    // TODO: [jaredsinclair] Clamp the appropriate x/y component to 0 when the
    // new value for `allowedPanningAxes` excludes it, so that the camera angles
    // are reset to their at-rest values.
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.rotateStart = point;
            break;
        case UIGestureRecognizerStateChanged:
            self.rotateCurrent = point;
            self.rotateDelta = subtractPoints(self.rotateStart, self.rotateCurrent);
            self.rotateStart = self.rotateCurrent;
            
            // TODO: [jaredsinclair] Clamp x/y components to 0 if the relevant axis is not
            // included in `allowedPanningAxes`.
        
            CGPoint position = CGPointMake(self.currentPosition.x + 2 * M_PI * self.rotateDelta.x / self.view.frame.size.width * 0.5,
                                           self.currentPosition.y + 2 * M_PI * self.rotateDelta.y / self.view.frame.size.height * 0.4);
            position.y = CLAMP(position.y, -M_PI / 2, M_PI / 2);
            self.currentPosition = position;
        
            self.camera.eulerAngles = SCNVector3Make(self.currentPosition.y, self.currentPosition.x, 0);
            break;
        default:
            break;
    }
}

@end
