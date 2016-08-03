//
//  NYT360MotionManager.m
//  ios-360-videos
//
//  Created by Jared Sinclair on 8/3/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

#import "NYT360MotionManager.h"
#import "NYT360CameraController.h"

///-----------------------------------------------------------------------------
/// NYT360MotionManagerObserverItem
///-----------------------------------------------------------------------------

@interface NYT360MotionManagerObserverItem: NSObject

@property (nonatomic, readonly) NSUUID *identifier;
@property (nonatomic) NSTimeInterval preferredUpdateInterval;

@end

@implementation NYT360MotionManagerObserverItem

- (instancetype)initWithPreferredUpdateInterval:(NSTimeInterval)interval {
    self = [super init];
    if (self) {
        _identifier = [NSUUID new];
        _preferredUpdateInterval = interval;
    }
    return self;
}

@end

///-----------------------------------------------------------------------------
/// NYT360MotionManager
///-----------------------------------------------------------------------------

@interface NYT360MotionManager ()

@property (nonatomic, readonly) NSMutableDictionary <__kindof NSUUID *, NYT360MotionManagerObserverItem *> *observerItems;
@property (nonatomic, readonly) CMMotionManager *motionManager;

@end

@implementation NYT360MotionManager

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        _observerItems = [NSMutableDictionary new];
        _motionManager = ({
            CMMotionManager *manager = [CMMotionManager new];
            manager.deviceMotionUpdateInterval = NYT360CameraControllerPreferredMotionUpdateInterval;
            manager;
        });
    }
    return self;
}

#pragma mark - NYTMotionManagement

- (BOOL)isDeviceMotionAvailable {
    return self.motionManager.isDeviceMotionAvailable;
}

- (BOOL)isDeviceMotionActive {
    return self.motionManager.isDeviceMotionActive;
}

- (CMDeviceMotion *)deviceMotion {
    return self.motionManager.deviceMotion;
}

- (NSUUID *)startUpdating:(NSTimeInterval)preferredUpdateInterval {
    NSAssert([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue], @"NYT360MotionManager may only be used on the main queue.");
    NSUInteger previousCount = self.observerItems.count;
    NYT360MotionManagerObserverItem *item = [[NYT360MotionManagerObserverItem alloc] initWithPreferredUpdateInterval:preferredUpdateInterval];
    self.observerItems[item.identifier] = item;
    self.motionManager.deviceMotionUpdateInterval = self.resolvedUpdateInterval;
    if (self.observerItems.count > 0 && previousCount == 0) {
        [self.motionManager startDeviceMotionUpdates];
    }
    return item.identifier;
}

- (void)stopUpdating:(NSUUID *)identifier {
    NSAssert([NSOperationQueue currentQueue] == [NSOperationQueue mainQueue], @"NYT360MotionManager may only be used on the main queue.");
    NSUInteger previousCount = self.observerItems.count;
    [self.observerItems removeObjectForKey:identifier];
    self.motionManager.deviceMotionUpdateInterval = self.resolvedUpdateInterval;
    if (self.observerItems.count == 0 && previousCount > 0) {
        [self.motionManager stopDeviceMotionUpdates];
    }
}

#pragma mark - Internal

- (NSUInteger)numberOfObservers {
    return self.observerItems.count;
}

- (NSTimeInterval)resolvedUpdateInterval {
    NSArray *allItems = self.observerItems.allValues;
    if (allItems.count == 0) {
        return NYT360CameraControllerPreferredMotionUpdateInterval;
    }
    return [[allItems valueForKeyPath:@"@max.preferredUpdateInterval"] doubleValue];
}

@end
