# Functional Core Image Filtering and Recording

This was really inspired by the [Functional Swift API's article in objc.io](https://www.objc.io/issues/16-swift/functional-swift-apis/
). They made a great code example there. However, it wasn't enough to fill our needs.

## Usage

I added five things:
 
* `CaptureBufferSource` - Class for capturing the camera and microphone content
* `CoreImageView` - Class for displaying the camera's content, which renders on the GPU.
* `Filter` - Type for Core Image Filters, which makes it easy to chain them, in a functional way. 
* `>|>` - Operator to chain flters
* `VideoWriter` - Class for recording the audio and video. 

#### CaptureBufferSource
Let's start with `CaptureBufferSource`. This is initialized with the position of the camera. It can capture Audio and Video. Both of the buffers can be capturesd in the callbacks. See code example below: 

```swift 
let videoCallback : BufferConsumer = { [weak self] (buffer) in
    guard let strongSelf = self else {
        return
    }

    let image = CIImage(buffer: buffer)
    strongSelf.coreImageView.image = image
}

let audioCallback : AudioBufferConsumer = { [weak self] (buffer) in
}

source = CaptureBufferSource(position: AVCaptureDevicePosition.Front, videoCallback: videoCallback, audioCallback: audioCallback)
source?.running = true
```

#### CoreImageView
`CoreImageView` can display the `CaptureBufferSource` image output (filtered or unfileterd). It's a subclass of `GLKView` and renderes on the GPU.

#### Filter and `>|>`
`Filter`s are Core Image Filters. They return a funtion that takes a `CIImage` and transforms it into a new one. There very easy to create and I've made a few in `Filters.swift`. They always have the same output with the same input (functional). 

They can be chained like this:

```swift            
let filter = blur(10) >|> hueAdjust(5) >|> compositeSourceOver(cropped(input))
self.coreImageView?.image = filter(input)
```

Notice the `>|>` operator. I'm most of the times against custom operators, but it makes a lot of sense here. 

###VideoWriter
Last but not least, we want to record all of this. To initialize a VideoWriter we simply have to give the dimensions of the output and the fileURL:

```swift
videoWriter = VideoWriter(fileUrl: currentMovieURL, height: 720, width: 720)
```

After that, whenever we capture a buffer, we can write that to the file. Note: we can write `CMSampleBuffer` and `CIImage` for video, for audio we can only use `CMSampleBuffer`. 
Writing goes like this: 

```swift
videoWriter.write(buffer, isVideo: true, image: image)
```
When finished, we get a callback with the finished file url.

```swift
videoWriter.finish({ url in
	// do something with the recorded file
})
```


## Resources

#### Filtering
* [CI Filter Recipes on developer.apple.com](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_filer_recipes/ci_filter_recipes.html)
* [CI Custom Filters Recipes on developer.apple.com](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_custom_filters/ci_custom_filters.html)
* [Core Image Filter Reference](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/CoreImageFilterReference/)
* [Core Image Intro in objc.io](https://www.objc.io/issues/21-camera-and-photos/core-image-intro/)
* [Core Image Video in objc.io](https://www.objc.io/issues/23-video/core-image-video/)
* [Core Image Explorer on GitHub](https://github.com/objcio/issue-21-core-image-explorer)
* [Functional Swift API's in objc.io](https://www.objc.io/issues/16-swift/functional-swift-apis/
) 
* [Rosy Writer Swift](https://github.com/waleedka/rosywriterswift)
* [GPUImage 2 redesigned Swift](http://www.sunsetlakesoftware.com/2016/04/16/introducing-gpuimage-2-redesigned-swift)
* [Image Resizing by NSHipster](http://nshipster.com/image-resizing/)
* [Cropping images on Stack Overflow](http://stackoverflow.com/questions/9601242/cropping-ciimage-with-cicrop-isnt-working-properly)
* [Tilt Shift in Swift Gist](https://gist.github.com/seivan/b5b2a7926028c179d4ba)
* [AVAssetReaderOutPut class](https://developer.apple.com/library/ios/documentation/AVFoundation/Reference/AVAssetReaderTrackOutput_Class/)
* [White balance question](http://stackoverflow.com/questions/15689745/can-white-balance-mode-be-controlled-on-starting-camera-app-ios)

#### Recording
* [Pitfalls and Errors When Using AVAssetWriter to Save the OpenGL Backbuffer Into a Video.](https://pompidev.net/tag/glkview/)
* [WWWDC session 520 (2012)](https://developer.apple.com/videos/play/wwdc2012/520/)
* [VideoWriter.swift](https://github.com/takecian/VineVideo/blob/master/VineVideo/VideoWriter.swift)


### Fixing strange Crashes
* [AVCaptureSession Crash with no Reason](http://stackoverflow.com/questions/9644899/avcapturesession-get-memory-warning-and-crash-with-no-reason)
* [ScrollView + GLKView](https://developer.apple.com/videos/play/wwdc2012/223/)
* [Animation Freeze ScrollView (Stack Overflow)](http://stackoverflow.com/questions/4876488/animation-in-opengl-es-view-freezes-when-uiscrollview-is-dragged-on-iphone)