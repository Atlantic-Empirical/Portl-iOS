# Potential Future Improvements

This is not a list of “need to do”, but a list of things that I think will become bottlenecks or bug-prone areas of the code that deserve rethinking/refactoring. Basically, foundational pieces that are core to the app experience and directly affect user experience or development speed.


### - Image cache changes

Need to have an intermediate representation of image requests. Essentially an image request object consisting of:
- Original URL
- Optimized URL
- Desired size

That way, when an image request comes in, we can see if we have the original around, or any higher-resolution version. This will improve local cache-hits for images.

The image cache should also have better updating/ejection logic. Right now when a true HTTP status code of 404 comes in, we do not invalidate the cached images, even though we should.


### - User invite / room creation flow

We are still waiting on the backend for this, but we really do need to make sure that there is a way to invite someone to a room, and upon finding out that they are not an app user, still require a “confirm invite” request.

Right now, when you hit the create room button, the user is invited, regardless of cancelling out of the server-side sms composer or not.


### - Message cell view cleanup

Message cells should be rebuilt (or cleaned up, if someone is confident enough). Essentially too much code is being duplicated between PTKMessageCell subclasses, and not everything is easy to navigate. Things should be organized into a more clear view hierarchy within the cells as well.

This will become more and more important as more integrations are added.


### - Presented media views

Same as above. We need a template to make building these quicker and more seamless.


### - General caching

I still unscientifically believe that our message cache logic is contributing to battery drain while in the background. Regardless of the level of severity, it is certainly higher than it actually needs to be. Right now, every time we receive a message notification, we read the room’s message history from disk, insert the new message, and then save the history back to disk.

The issue here isn’t that we are doing this multiple times per second (so any disk-level coalescing wouldn’t help), it is that we are doing it at all over the course of an app session while we have live memory.

Essentially, there should be a caching class that holds everything in memory (LRU), and then periodically flushes the data to disk. Where periodically is: on app background, app terminate, and X minutes while in foreground, and Y minutes while in background. This will have the added effect of making everything faster (particularly entering a room, which fetches cached messages). Can’t complain about that!


### - Contact upload improvements

Right now, contact uploads can be up to 1MB in size. If we GZIP the POST body on upload, we could significantly reduce the transfer size. This would save both the user’s data plan, as well as significantly reducing the latency on the contact upload request (since user uplink speeds/limits are lower than downlink).

This would require coordinating with the backend to ensure that Deathstar can received a GZIP’d POST body.

We should also break up the upload process into chunks. So instead of uploading all of the contacts at once, we can upload them in chunks of say, 50.

Contact upload sizes were already an issue when the limit was <1MB: https://airtime.atlassian.net/browse/DRK-121


### - Project setup process

All of the required certificates and provisioning files should be included in the project, and an accompanying provision.sh file should be included to fully provision the developer’s computer.

This may or may not be worth it from the perspective of actually onboarding developers (they will still need to add their device to the developer account), but will streamline the process going forward of automated builds.
