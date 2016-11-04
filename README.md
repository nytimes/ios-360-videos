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

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b my-awesome-new-feature`
3. Commit your changes: `git commit -m 'Add some awesome feature'`
4. Push to the branch: `git push origin my-awesome-new-feature`
5. Submit a pull request

## License

- This code is under [Apache 2.0
  license](https://github.com/NYTimes/ios-360-videos/blob/master/LICENSE.md).
