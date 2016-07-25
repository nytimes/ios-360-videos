Pod::Spec.new do |s|
    s.name             = 'Three60_Player'
    s.version          = '0.1.0'
    s.summary          = 'Three60_Player plays 360º video streamed from an AVPlayer.'

    s.description      = <<-DESC
    Three60_Player from The New York Times is a view controller allowing playback of a 360º video stream from an `AVPlayer`.

    It provides no control user interface; it is intended to be embedded in your own video player implementation.
    DESC

    s.homepage         = 'https://github.com/nytm/ios-360-videos/'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = 'The New York Times'
    s.source           = { :git => 'https://github.com/nytm/ios-360-videos.git', :tag => s.version.to_s }

    s.ios.deployment_target = '9.0'

    s.source_files = 'Sources/**/*.{h,m}'
    s.public_header_files = 'Sources/Three60_Player.h', 'Sources/NYT360ViewController.h'

    s.frameworks = 'UIKit', 'SceneKit', 'SpriteKit', 'AVFoundation', 'CoreMotion'
end
