//
//  NYT360DataTypes.h
//  NYT360Video
//
//  Created by Jared Sinclair on 7/27/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import Foundation;

typedef NS_OPTIONS(NSInteger, NYT360PanningAxis) {
    NYT360PanningAxisHorizontal = 1 << 0,
    NYT360PanningAxisVertical   = 1 << 1,
};

typedef NS_ENUM(NSInteger, NYT360UserInteractionMethod) {
    NYT360UserInteractionMethodGyroscope = 0,
    NYT360UserInteractionMethodTouch,
};
