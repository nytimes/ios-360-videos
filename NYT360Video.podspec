Pod::Spec.new do |s|
    s.name             = 'NYT360Video'
    s.version          = '0.6.0'
    s.summary          = 'NYT360Video plays 360º video streamed from an AVPlayer.'

    s.description      = <<-DESC
    NYT360Video from The New York Times is a framework allowing playback of a 360º video stream from an `AVPlayer`.

    It provides no control user interface; it is intended to be embedded in your own video player implementation.
    DESC

    s.homepage         = 'https://github.com/nytm/ios-360-videos/'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = 'The New York Times'
    s.source           = { :git => 'git@github.com:nytm/ios-360-videos.git', :tag => s.version.to_s }

    s.ios.deployment_target = '8.0'

    s.source_files = 'Sources/**/*.{h,m}'
    s.public_header_files = 'Sources/NYT360Video.h', 'Sources/NYT360ViewController.h', 'Sources/NYT360DataTypes.h', 'Sources/NYT360MotionManagement.h', 'Sources/NYT360MotionManager.h', 'Sources/NYT360CameraPanGestureRecognizer.h'

    s.frameworks = 'UIKit', 'SceneKit', 'SpriteKit', 'AVFoundation', 'CoreMotion'
end
