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
#import "NYT360EulerAngleCalculations.h"
#import "NYTMotionManagement.h"

static inline CGPoint subtractPoints(CGPoint a, CGPoint b) {
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
        _allowedPanningAxes = NYT360PanningAxisHorizontal | NYT360PanningAxisVertical;
        
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
    NYT360EulerAngleCalculationResult result;
    result = NYT360DeviceMotionCalculation(self.currentPosition, rotationRate, orientation, self.allowedPanningAxes, NYT360EulerAngleCalculationNoiseThresholdDefault);
    self.currentPosition = result.position;
    self.camera.eulerAngles = result.eulerAngles;
}

- (void)setAllowedPanningAxes:(NYT360PanningAxis)allowedPanningAxes {
    // TODO: [jaredsinclair] Consider adding an animated version of this method.
    if (_allowedPanningAxes != allowedPanningAxes) {
        _allowedPanningAxes = allowedPanningAxes;
        NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(self.currentPosition, allowedPanningAxes);
        self.currentPosition = result.position;
        self.camera.eulerAngles = result.eulerAngles;

    }
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
            NYT360EulerAngleCalculationResult result = NYT360PanGestureChangeCalculation(self.currentPosition, self.rotateDelta, self.view.bounds.size, self.allowedPanningAxes);
            self.currentPosition = result.position;
            self.camera.eulerAngles = result.eulerAngles;
            break;
        default:
            break;
    }
}

@end
