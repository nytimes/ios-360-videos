# NYT360Video
[![Version](https://img.shields.io/cocoapods/v/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)
[![License](https://img.shields.io/cocoapods/l/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)
[![Platform](https://img.shields.io/cocoapods/p/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## 360º video playback from The New York Times

NYT360Video plays [spherical 360º video](https://en.wikipedia.org/wiki/360-degree_video), allowing the user to explore the video via pan gestures and the iOS device’s gyroscope. The video can be played from a file or network stream, via a standard `AVPlayer` instance.

It provides no user interface for playback controls (like a play/pause button); it is intended to be embedded in your own video player implementation.

At the Times we use NYT360Video to support playback of our own content:

![Animation of 360º video playback in the Times’ iPhone app](Documentation/360.gif)

## Usage

[`NYT360ViewController`](https://github.com/NYTimes/ios-360-videos/blob/develop/Sources/NYT360ViewController.h) is the entry point for the library. [Initialize](https://github.com/NYTimes/ios-360-videos/blob/68c522d51d6c88ddd705e4febbb480de825cdc5d/Sources/NYT360ViewController.h#L67) it with an `AVPlayer` instance and your application’s motion manager. (Motion management is discussed in the next section.)

Once it’s initialized, embed your `NYT360ViewController` instance in your view hierarchy via [view controller containment](https://www.objc.io/issues/1-view-controllers/containment-view-controller/).

[The Example application demonstrates](https://github.com/NYTimes/ios-360-videos/blob/develop/NYT360VideoExample/ViewController.m) how to set this up.

### Motion Management

Apple’s documentation warns,

> An app should create only a single instance of the `CMMotionManager` class.

To cope with this limitation, NYT360Video doesn’t have to create its own `CMMotionManager` instance to receive device motion updates. Instead, you’ll inject a motion manager when you create a `NYT360ViewController`.

The expectations for this motion manager are set by [the `NYT360MotionManagement` protocol](https://github.com/NYTimes/ios-360-videos/blob/develop/Sources/NYT360MotionManagement.h); see the header for a detailed description of those requirements.

If your application doesn’t use `CMMotionManager` elsewhere, you can simply use [the `NYT360MotionManager` singleton provided with this library](https://github.com/NYTimes/ios-360-videos/blob/develop/Sources/NYT360MotionManager.h) to fulfill these requirements.

Otherwise, if your app has a motion manager already, you’ll need to make it conform to [`NYT360MotionManagement`](https://github.com/NYTimes/ios-360-videos/blob/develop/Sources/NYT360MotionManagement.h) and use it when creating a `NYT360ViewController`.

### Managing Gesture Interactions

You may want to restrict the gesture-based interactions with `NYT360ViewController` in certain cases in your application — for example, when embedded in a vertically-scrolling view, `NYT360ViewController` should not intercept vertical pan gestures. There are a few ways to accomplish this with NYT360Video.

First, [`NYT360ViewController` provides properties](https://github.com/NYTimes/ios-360-videos/blob/68c522d51d6c88ddd705e4febbb480de825cdc5d/Sources/NYT360ViewController.h#L111) to configure which axes of movement are allowed. (This would be the simplest way to solve the example problem set out above.)

The library exposes its pan gesture recognizer as a property on `NYT360ViewController` for more advanced ingegration with other gesture recognizers. And finally, the type `NYT360CameraPanGestureRecognizer` is introduced so that host applications can more easily configure interaction with other gesture recognizers, without having to refer to specific instances of an NYT360Video gesture recognizer.

## Requirements

NYT360Video works on iOS 8+.

## Installation

### Carthage

NYT360Video may be fetched and built via [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your `Cartfile`:

```
github "NYTimes/ios-360-videos"
```

Then, following the instructions for [integrating Carthage frameworks into your app](https://github.com/Carthage/Carthage#if-youre-building-for-ios-tvos-or-watchos), link the `NYT360Video` framework into your project.

### CocoaPods

NYT360Video is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod 'NYT360Video'
```

## Known Issues

- **iOS 10 CoreAudio Crash** - On devices running iOS 10 (at least as of Beta 7), host applications will crash if the device is locked while an `NYT360ViewController` is visible (whether paused or not). The crash is caused by a CoreAudio exception. A workaround that appears to work for some, though not all, apps is to enable the background audio capability in the host application’s plist. [An extended discussion of the issue can be found in issue #37](https://github.com/nytimes/ios-360-videos/issues/37).

_See also [this project’s issue tracker](https://github.com/NYTimes/ios-360-videos/issues)._

## Contributing

Contributions are welcomed via GitHub’s pull request system. As a note:

- Contributions which include unit tests, where feasible, are likely to be merged more easily.
- Pull requests which add player UI are unlikely to be accepted. We consider that to be a separate responsibility; this library aims to provide only lower-level 360º-specific playback functionality.

1. [Fork this repository](https://github.com/NYTimes/ios-360-videos/fork)
2. Create your feature branch: `git checkout -b my-awesome-new-feature`
3. Commit your changes: `git commit -m 'Add some awesome feature'`
    _Please split your commits up logically, and be sure to write [good commit messages](https://www.dzombak.com/blog/2015/10/Writing-good-commit-messages.html)._
4. Push to your branch: `git push origin my-awesome-new-feature`
5. Submit a [pull request](https://github.com/NYTimes/ios-360-videos/pulls) to this repository

## Version History

See [CHANGELOG.md](CHANGELOG.md).

## License

NYT360Video is released under the [Apache 2.0 license](LICENSE.md).
