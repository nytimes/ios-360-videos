//
//  NYT360ViewControllerTests.m
//  NYT360VideoTests
//
//  Created by Jared Sinclair on 8/2/16.
//  Copyright © 2016 The New York Times Company. All rights reserved.
//

@import XCTest;

#define NYTXCTAssertRectsEqualWithAccuracy(rectA, rectB, accuracy) \
XCTAssertEqualWithAccuracy(rectA.origin.x, rectB.origin.x, accuracy); \
XCTAssertEqualWithAccuracy(rectA.origin.y, rectB.origin.y, accuracy); \
XCTAssertEqualWithAccuracy(rectA.size.width, rectB.size.width, accuracy); \
XCTAssertEqualWithAccuracy(rectA.size.height, rectB.size.height, accuracy); \

static const CGFloat NYT360ViewControllerTestsAccuracy = 0.1;

#import "NYT360ViewController.h"

@interface NYT360ViewControllerTests : XCTestCase

@end

@implementation NYT360ViewControllerTests

#pragma mark - NYT360ViewControllerSceneBoundsForScreenBounds()

- (void)testItDerivesLandscapeBoundsFromLandscape {
    CGRect screenBounds = CGRectMake(0, 0, 568, 320);
    CGRect actual = NYT360ViewControllerSceneBoundsForScreenBounds(screenBounds);
    CGRect expected = CGRectMake(0, 0, 568, 320);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testItDerivesLandscapeBoundsFromPortrait {
    CGRect screenBounds = CGRectMake(0, 0, 320, 568);
    CGRect actual = NYT360ViewControllerSceneBoundsForScreenBounds(screenBounds);
    CGRect expected = CGRectMake(0, 0, 568, 320);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testItIgnoresNonZeroOriginValues {
    CGRect screenBounds = CGRectMake(-20, 64, 320, 568);
    CGRect actual = NYT360ViewControllerSceneBoundsForScreenBounds(screenBounds);
    CGRect expected = CGRectMake(0, 0, 568, 320);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

#pragma mark - NYT360ViewControllerSceneFrameForContainingBounds()

- (void)testItFillsAnIdenticalLandscapeContainer {
    CGRect containingBounds = CGRectMake(0, 0, 568, 320);
    CGSize underlyingSize = CGSizeMake(568, 320);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(0, 0, 568, 320);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testItFillsACongruentPortraitContainer {
    CGRect containingBounds = CGRectMake(0, 0, 320, 568);
    CGSize underlyingSize = CGSizeMake(568, 320);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(-344.1, 0, 1008.2, 568);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testLandscapeUnderlyingSizeScalesToFillAnIncongruentLandscapeContainer {
    CGRect containingBounds = CGRectMake(0, 0, 1024, 768);
    CGSize underlyingSize = CGSizeMake(568, 320);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(-169.6, 0, 1363.2, 768);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testLandscapeUnderlyingSizeScalesToFillAnIncongruentPortraitContainer {
    CGRect containingBounds = CGRectMake(0, 0, 768, 1024);
    CGSize underlyingSize = CGSizeMake(568, 320);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(-524.8, 0, 1817.6, 1024);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testSquareUnderlyingSizeScalesToFillAnIncongruentLandscapeContainer {
    CGRect containingBounds = CGRectMake(0, 0, 1024, 768);
    CGSize underlyingSize = CGSizeMake(720, 720);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(0, -128, 1024, 1024);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

- (void)testSquareUnderlyingSizeScalesToFillAnIncongruentPortraitContainer {
    CGRect containingBounds = CGRectMake(0, 0, 768, 1024);
    CGSize underlyingSize = CGSizeMake(720, 720);
    CGRect actual = NYT360ViewControllerSceneFrameForContainingBounds(containingBounds, underlyingSize);
    CGRect expected = CGRectMake(-128, 0, 1024, 1024);
    NYTXCTAssertRectsEqualWithAccuracy(actual, expected, NYT360ViewControllerTestsAccuracy);
}

@end
