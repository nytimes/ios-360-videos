# NYT360Video
## 360º video playback from The New York Times

[![Version](https://img.shields.io/cocoapods/v/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)
[![License](https://img.shields.io/cocoapods/l/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)
[![Platform](https://img.shields.io/cocoapods/p/NYT360Video.svg?style=flat)](http://cocoapods.org/pods/NYT360Video)

NYT360Video is a framework allowing playback of a 360º video stream from an `AVPlayer`.

It provides no control user interface; it is intended to be embedded in your own video player implementation.

## Usage

TKTK

## Requirements

TKTK

## Installation

### Carthage

TKTK

### CocoaPods

NYT360Video is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod 'NYT360Video'
```

## Known Issues

- **iOS 10 CoreAudio Crash** - On devices running iOS 10 (at least as of Beta 7), host applications will crash if the device is locked while an NYT360ViewController is visible (whether paused or not). The crash is caused by a CoreAudio exception. [An extended discussion of the issue can be found here](https://github.com/nytm/ios-360-videos/issues/37). A workaround that appears to work for some, though not all, apps is to enable the background audio capability in the host application's plist.

## Authors

- Maxwell Dayvson Da Silva: <maxwell.dasilva@nytimes.com>
- Thiago Pontes de Oliveira: <thiago.pontes@nytimes.com>
- Chris Dzombak: <dzombak@nytimes.com>
- Danny Zlobinsky <danny.zlobinsky@nytimes.com>

## License

NYT360Video is licensed under the Apache License version 2.0; see [`LICENSE`](LICENSE) for detail.
