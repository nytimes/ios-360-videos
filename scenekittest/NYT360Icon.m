//
//  NYT360Icon.m
//  scenekittest
//
//  Created by Dasilva, Maxwell on 7/14/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360Icon.h"
@interface NYT360Icon ()

@property (nonatomic) CAShapeLayer *iconLayer;

@end

@implementation NYT360Icon

- (id)init:(CGRect)area {
    self = [super init];
    _iconLayer = [self drawOutsideCircle:area];
    CAShapeLayer *leftEye = [self drawCircle:CGRectMake(42, 45, 5, 5)];
    CAShapeLayer *rightEye = [self drawCircle:CGRectMake(52, 45, 5, 5)];
    
    [_iconLayer addSublayer:leftEye];
    [_iconLayer addSublayer:rightEye];
    _iconLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _iconLayer.position = CGPointMake(area.origin.x, area.origin.y);
    _iconLayer.bounds = CGPathGetBoundingBox(_iconLayer.path);
    
    [self addSublayer:_iconLayer];
    return self;
}

- (CAShapeLayer *)drawFov {
    CAShapeLayer *shape = [CAShapeLayer layer];
    return shape;
}

- (void)updateRotation:(int)degree {
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(degree);
    [_iconLayer setAffineTransform:rotateTransform];
    NSLog(@"update rotation to angle %d", degree);
}

- (CAShapeLayer *)drawOutsideCircle:(CGRect)area {
    CAShapeLayer *circle = [CAShapeLayer layer];
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, area.size.width, area.size.height)] CGPath]];
    [circle setStrokeColor:[[UIColor whiteColor] CGColor]];
    [circle setFillColor:[[UIColor clearColor] CGColor]];
    return circle;
}

- (CAShapeLayer *)drawCircle:(CGRect)position {
    CAShapeLayer *circle = [CAShapeLayer layer];
    [circle setPath:[[UIBezierPath bezierPathWithOvalInRect:position] CGPath]];
    [circle setFillColor:[[UIColor whiteColor] CGColor]];
    return circle;
}

@end
