//
//  NYT360CameraController.m
//  NYT360Video
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360CameraController.h"
#import "NYT360EulerAngleCalculations.h"
#import "NYT360CameraPanGestureRecognizer.h"

static const CGPoint startingPosition = { 3.14, 0 };

static inline CGFloat distance(CGPoint a, CGPoint b) {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
}

static inline CGPoint subtractPoints(CGPoint a, CGPoint b) {
    return CGPointMake(b.x - a.x, b.y - a.y);
}

@interface NYT360CameraController ()

@property (nonatomic) SCNView *view;
@property (nonatomic) id<NYT360MotionManagement> motionManager;
@property (nonatomic, strong, nullable) NYT360MotionManagementToken motionUpdateToken;
@property (nonatomic) SCNNode *pointOfView;

@property (nonatomic, assign) CGPoint rotateStart;
@property (nonatomic, assign) CGPoint rotateCurrent;
@property (nonatomic, assign) CGPoint rotateDelta;
@property (nonatomic, assign) CGPoint currentPosition;

@property (nonatomic, assign) BOOL isAnimatingReorientation;
@property (nonatomic, assign) BOOL hasReportedInitialCameraMovement;

@end

@implementation NYT360CameraController

#pragma mark - Initializers

- (instancetype)initWithView:(SCNView *)view motionManager:(id<NYT360MotionManagement>)motionManager {
    self = [super init];
    if (self) {
        
        NSAssert(view.pointOfView != nil, @"NYT360CameraController must be initialized with a view with a non-nil pointOfView node.");
        NSAssert(view.pointOfView.camera != nil, @"NYT360CameraController must be initialized with a view with a non-nil camera node for view.pointOfView.");
        
        _pointOfView = view.pointOfView;
        _view = view;
        _currentPosition = startingPosition;
        _allowedDeviceMotionPanningAxes = NYT360PanningAxisHorizontal | NYT360PanningAxisVertical;
        _allowedPanGesturePanningAxes = NYT360PanningAxisHorizontal | NYT360PanningAxisVertical;
        
        _panRecognizer = [[NYT360CameraPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panRecognizer.delegate = self;
        [_view addGestureRecognizer:_panRecognizer];
        
        _motionManager = motionManager;

        _hasReportedInitialCameraMovement = NO;
    }
    
    return self;
}

#pragma mark - Observing Device Motion

- (void)startMotionUpdates {
    static const NSTimeInterval preferredMotionUpdateInterval = (1.0 / 60.0);

    NSTimeInterval interval = preferredMotionUpdateInterval;
    self.motionUpdateToken = [self.motionManager startUpdating:interval];
}

- (void)stopMotionUpdates {
    if (self.motionUpdateToken == nil) { return; }
    [self.motionManager stopUpdating:self.motionUpdateToken];
    self.motionUpdateToken = nil;
}

#pragma mark - Compass Angle

- (float)compassAngle {
    return NYT360CompassAngleForEulerAngles(self.pointOfView.eulerAngles);
}

#pragma mark - Camera Control

- (void)updateCameraAngleForCurrentDeviceMotion {
    
    // Ignore input during reorientation animations since SceneKit doesn't
    // provide a way to do so smoothly. The "jump" to the updated values would
    // be jarring otherwise.
    if (self.isAnimatingReorientation) { return; }


#ifdef DEBUG
#if !TARGET_IPHONE_SIMULATOR
    if (!self.motionManager.isDeviceMotionActive) {
        NSLog(@"Warning: %@ called while %@ is not receiving motion updates", NSStringFromSelector(_cmd), NSStringFromClass(self.class));
    }
#endif
#endif

    CMRotationRate rotationRate = self.motionManager.deviceMotion.rotationRate;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    NYT360EulerAngleCalculationResult result;
    result = NYT360DeviceMotionCalculation(self.currentPosition, rotationRate, orientation, self.allowedDeviceMotionPanningAxes, NYT360EulerAngleCalculationNoiseThresholdDefault);
    self.currentPosition = result.position;
    self.pointOfView.eulerAngles = result.eulerAngles;

    if (self.compassAngleUpdateBlock) {
        self.compassAngleUpdateBlock(self.compassAngle);
    }
    
    static const CGFloat minimalRotationDistanceToReport = 0.75;
    if (distance(startingPosition, self.currentPosition) > minimalRotationDistanceToReport) {
        [self reportInitialCameraMovementIfNeededViaMethod:NYT360UserInteractionMethodGyroscope];
    }
}

- (void)updateCameraFOV:(CGSize)viewSize {
    self.pointOfView.camera.yFov = NYT360OptimalYFovForViewSize(viewSize);
}

- (void)reorientVerticalCameraAngleToHorizon:(BOOL)animated {
    
    if (animated) {
        self.isAnimatingReorientation = YES;
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:[CATransaction animationDuration]];
    }
    
    CGPoint position = self.currentPosition;
    position.y = 0;
    self.currentPosition = position;
    
    SCNVector3 eulerAngles = self.pointOfView.eulerAngles;
    eulerAngles.x = 0; // Vertical camera angle = rotation around the x axis.
    self.pointOfView.eulerAngles = eulerAngles;
    
    if (animated) {
        [SCNTransaction setCompletionBlock:^{
            // Reset the transaction duration to 0 since otherwise further
            // updates from device motion and pan gesture recognition would be
            // subject to a non-zero implicit duration.
            [SCNTransaction setAnimationDuration:0];
            self.isAnimatingReorientation = NO;
        }];
        [SCNTransaction commit];
    }
    
}

#pragma mark - Panning Options

- (void)setAllowedDeviceMotionPanningAxes:(NYT360PanningAxis)allowedDeviceMotionPanningAxes {
    // TODO: [jaredsinclair] Consider adding an animated version of this method.
    if (_allowedDeviceMotionPanningAxes != allowedDeviceMotionPanningAxes) {
        _allowedDeviceMotionPanningAxes = allowedDeviceMotionPanningAxes;
        NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(self.currentPosition, allowedDeviceMotionPanningAxes);
        self.currentPosition = result.position;
        self.pointOfView.eulerAngles = result.eulerAngles;
    }
}

- (void)setAllowedPanGesturePanningAxes:(NYT360PanningAxis)allowedPanGesturePanningAxes {
    // TODO: [jaredsinclair] Consider adding an animated version of this method.
    if (_allowedPanGesturePanningAxes != allowedPanGesturePanningAxes) {
        _allowedPanGesturePanningAxes = allowedPanGesturePanningAxes;
        NYT360EulerAngleCalculationResult result = NYT360UpdatedPositionAndAnglesForAllowedAxes(self.currentPosition, allowedPanGesturePanningAxes);
        self.currentPosition = result.position;
        self.pointOfView.eulerAngles = result.eulerAngles;
    }
}

#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    
    // Ignore input during reorientation animations since SceneKit doesn't
    // provide a way to do so smoothly. The "jump" to the updated values would
    // be jarring otherwise.
    if (self.isAnimatingReorientation) { return; }
    
    CGPoint point = [recognizer locationInView:self.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.rotateStart = point;
            break;
        case UIGestureRecognizerStateChanged:
            self.rotateCurrent = point;
            self.rotateDelta = subtractPoints(self.rotateStart, self.rotateCurrent);
            self.rotateStart = self.rotateCurrent;
            NYT360EulerAngleCalculationResult result = NYT360PanGestureChangeCalculation(self.currentPosition, self.rotateDelta, self.view.bounds.size, self.allowedPanGesturePanningAxes);
            self.currentPosition = result.position;
            self.pointOfView.eulerAngles = result.eulerAngles;
            if (self.compassAngleUpdateBlock) {
                self.compassAngleUpdateBlock(self.compassAngle);
            }
            [self reportInitialCameraMovementIfNeededViaMethod:NYT360UserInteractionMethodTouch];
            break;
        default:
            break;
    }
}

- (void)reportInitialCameraMovementIfNeededViaMethod:(NYT360UserInteractionMethod)method {
    // only fire once per video:
    if (!self.hasReportedInitialCameraMovement) {
        self.hasReportedInitialCameraMovement = YES;
        [self.delegate cameraController:self userInitallyMovedCameraViaMethod:method];
    }
}

@end
