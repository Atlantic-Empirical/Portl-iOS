# GIFs

### Displaying + Performance

GIF rendering is not natively supported in iOS. As a result, we have a number of options:

##### - Extract the GIF data into a `UIAnimatedImage` (a subclass of `UIImage`)
Source/example: https://github.com/Flipboard/FLAnimatedImage

- Pros: Very simple, straightforward. Easy to pass the object around to multiple classes. Works natively with `UIImageView`.
- Cons: For large GIFs, can cause memory issues (because it needs to decode the entire GIF into memory, and actually entirely new set of frames!)

##### - Render GIF frames driven by a timer
Source/example: https://github.com/Flipboard/FLAnimatedImage

- Pros: Memory efficient. Lower immediate CPU load on instantiation.
- Cons: Utilizes the CPU for it's work (as opposed to GPU). Needs to continuously decode frames as it does not keep much in memory. Not easy to pass the same instance around to multiple views. Only works with it's own `FLAnimatedImageView` class.

##### - Convert GIFs to MP4s and use `AVPlayerLayer`
Source/example: http://techcrunch.com/2014/06/19/gasp-twitter-gifs-arent-actually-gifs/

- Pros: Same exact visual + behavior. Best CPU and memory performance. **Lowest file size.**
- Cons: You need to have an MP4 file for the GIF... Also, `AVPlayerLayer` isn't the easiest to prevent from blocking the main thread (though we seem to have it working pretty well).
