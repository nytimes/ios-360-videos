//
//  NYT360Icon.h
//  scenekittest
//
//  Created by Dasilva, Maxwell on 7/14/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SpriteKit;
@interface NYT360Icon : CAShapeLayer
- (id)init:(CGRect)area;
- (void)updateRotation:(int)degree;
@end
