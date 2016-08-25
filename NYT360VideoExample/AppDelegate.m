//
//  AppDelegate.m
//  NYT360VideoExample
//
//  Created by Chris Dzombak on 7/25/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "AppDelegate.h"

@import AVFoundation;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // On iOS 10, at least as of Beta 7, using AVPlayer with SceneKit will lead
    // to an uncaught CoreAudio exception whenever the device becomes locked.
    // The only workaround for now is to both a) enable background audio in the
    // app's plist and b) set the AVAudioSession category to AVAudioSessionCategoryPlayback.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    return YES;
}

@end
