//
//  NYT360CameraPanGestureRecognizer.h
//  NYT360Video
//
//  Created by Jared Sinclair on 8/5/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import UIKit;

/**
 *  An otherwise vanilla subclass of UIPanGestureRecognizer used by NYT360Video to enable manual camera panning.
 *
 *  This class is exposed so that host applications can more easily configure interaction with other gesture recognizers, without having to refer to specific instances of an NYT360Video gesture recognizer.
 */
@interface NYT360CameraPanGestureRecognizer : UIPanGestureRecognizer
@end
