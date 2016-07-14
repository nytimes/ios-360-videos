//
//  Controls.h
//  scenekittest
//
//  Created by Thiago on 7/13/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

@import UIKit;

@class SCNView;

NS_ASSUME_NONNULL_BEGIN

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

#pragma mark - Initializers

- (instancetype)initWithView:(SCNView *)view;

#pragma mark - Observing Device Motion

- (void)startMotionUpdates;
- (void)stopMotionUpdates;

#pragma mark -

- (void)updateCameraAngle;

@end

NS_ASSUME_NONNULL_END
