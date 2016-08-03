//
//  NYT360Icon.m
//  scenekittest
//
//  Created by Thiago on 7/25/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360Icon.h"

@implementation NYT360Icon

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self didLoad];
    return self;
}

- (void)updateRotation:(float)radians {
    self.transform = CGAffineTransformMakeRotation(radians);
}

- (void)didLoad {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 3.0;
    
    [self drawLine];
}

- (void)drawLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    [path addLineToPoint:CGPointMake(150, 50)];
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.path = [path CGPath];
    shapeLayer.strokeColor = [[UIColor blueColor] CGColor];
    shapeLayer.lineWidth = 3.0;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:shapeLayer];
}

@end
