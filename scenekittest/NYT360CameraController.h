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

@interface NYT360CameraController : NSObject <UIGestureRecognizerDelegate>

#pragma mark - Initializers

- (instancetype)initWithView:(SCNView *)view;

#pragma mark -

- (void)update;

@end

NS_ASSUME_NONNULL_END
