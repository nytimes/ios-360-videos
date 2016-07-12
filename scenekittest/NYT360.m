//
//  NYT360.m
//  scenekittest
//
//  Created by Thiago on 7/11/16.
//  Copyright © 2016 The New York Times. All rights reserved.
//

#import "NYT360.h"

@implementation NYT360

- (id) initWithAVPlayer: (AVPlayer *)player {
    self = [super initWithFrame:CGRectMake(0, 0, 500, 500)];
    
    
    NSDictionary *pixelBuffAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange)};
    _videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes:pixelBuffAttributes];
    [_videoOutput requestNotificationOfMediaDataChangeWithAdvanceInterval:0.033];

    SCNScene *scene = [[SCNScene alloc] init];
    SCNCamera *camera = [[SCNCamera alloc] init];
    SCNSphere *sphere = [[SCNSphere alloc] init];
    SCNNode *cameraNode = [[SCNNode alloc] init];
    self.node = [[SCNNode alloc] init];
    SCNMaterial *material = [[SCNMaterial alloc] init];
    
    self.backgroundColor = [UIColor redColor];
    sphere.radius = 10.0f;
    sphere.firstMaterial = material;
    
    
    self.node.geometry = sphere;
    
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(4, 5, 30);
    
    self.scene = scene;
    
    
    self.pointOfView = cameraNode;
    
    [scene.rootNode addChildNode: self.node];
    
    self.delegate = self;
    self.autoenablesDefaultLighting = true;
    return self;
}

- (void)renderer:(id<SCNSceneRenderer>)renderer
  didRenderScene:(SCNScene *)scene
          atTime:(NSTimeInterval)time {
    NSLog(@"rendering");
}

- (void) drawVideo {
    AVPlayerItem *item = [_player currentItem];
    if ([_videoOutput hasNewPixelBufferForItemTime:[item currentTime]]) {
        NSLog(@"Has new pixel buffer");
        CVPixelBufferRef pixelBuffer = [_videoOutput copyPixelBufferForItemTime:[item currentTime] itemTimeForDisplay:nil];
        UIImage *image = [self imageWithCVPixelBufferUsingUIGraphicsContext:pixelBuffer];
        GLKTextureInfo *texture = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:nil];
        self.node.geometry.firstMaterial.diffuse.contents = texture;

    } else {
        NSLog(@"no pixel buffer");
    }
    
}

- (UIImage *)imageWithCVPixelBufferUsingUIGraphicsContext:(CVPixelBufferRef)pixelBuffer {
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    int w = CVPixelBufferGetWidth(pixelBuffer);
    int h = CVPixelBufferGetHeight(pixelBuffer);
    int r = CVPixelBufferGetBytesPerRow(pixelBuffer);
    int bytesPerPixel = r/w;
    unsigned char *bufferU = CVPixelBufferGetBaseAddress(pixelBuffer);
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    CGContextRef c = UIGraphicsGetCurrentContext();
    unsigned char* data = CGBitmapContextGetData(c);
    if (data) {
        int maxY = h;
        for(int y = 0; y < maxY; y++) {
            for(int x = 0; x < w; x++) {
                int offset = bytesPerPixel*((w*y)+x);
                data[offset] = bufferU[offset];     // R
                data[offset+1] = bufferU[offset+1]; // G
                data[offset+2] = bufferU[offset+2]; // B
                data[offset+3] = bufferU[offset+3]; // A
            }
        }
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    CFRelease(pixelBuffer);
    return image;
}

@end
