## VOIP Notifications

All of the client-side logic for VOIP notifications should be in `PTKPushManager`

> The PushKit framework provides the classes for your iOS apps to receive pushes from remote servers. Pushes can be of one of two types: standard and VoIP. Standard pushes can deliver notifications just as in previous versions of iOS. VoIP pushes provide additional functionality on top of the standard push that is needed to VoIP apps to perform on-demand processing of the push before displaying a notification to the user.


####TL;DR;

VOIP notifications are a special type of regular APNS notifications. The differences:

- VOIP notifications can only be used by VOIP apps
- VOIP notifications have a slightly higher payload limit (might be matched recently)
- VOIP notifications have a higher delivery priority
- VOIP notifications give the app background execution time
- VOIP notifications are able to launch (in the background) the app from a killed state
- VOIP notifications do not require user permission to grab a token
- VOIP noitifcations do not badge the app icon
- VOIP notifications do not display a message
- VOIP notifications do not play a sound
- VOIP notifications **are inconsistently unreliable**


Requesting a VOIP notification is slightly different than a regular push token, although easier and less restricted. You simply need to create a `PKPushRegistry`, and no user permission is required. The caveat is that you can only display a `UILocalNotification` now after receiving permission.


#### When a VOIP notification comes in

Take a look at `-pushRegistry:didReceiveIncomingPushWithPayload:forType:` in `PTKPushManager`

- Auxiliary logic
   - Send an ACK request to deathstar if the notification contains an id
   - Post a local `kNotificationRoomNewMessage` via `NSNotificationCenter` with the message object (if applicable)
   - Fire "notification_received" analytics event
- Local notification logic
  - Only executes if backgrounded
  - Grab the notification payload, which should mirror that of a regular APNS
  - Clear excessive notifications
  - If "shouldCollapse" = YES, clear notifications with the same "collapseKey"
  - Craft a `UILocalNotification` using the payload
  - The `UILocalNotification` needs to have a repeat interval so that it can be cancelled later


#### Debugging process

Sometimes VOIP notifications will flat out stop working. As a result, we have a "notification fallback" system implemented on the backend. Essentially, if the backend does not receive an ACK (see above) for a VOIP notification for greater than 30 seconds, the backend will consider the app's VOIP connection to be unavailable (and will no longer send VOIP notifications until the next time the app posts it's VOIP token).

As a result, if there is a scenario where a device is not receiving push notifications but it should, wait about a minute and see if it starts receiving notifications. If not, then the server isn't sending them, or the device simply isn't recieiving notifications. Or, the user is muted.

A good quick test when not receiving notifications is to have someone invite the user to a new room. New room invite notifications are always over traditional APNS (as these notifications do not need collapse logic). If these pushes are also not coming through, it means that the issue is not VOIP notifications. If a regular APNS notification is not coming through, there is nothing we can do client-side.

There is currently logic on the backend (Stormtrooper + Wampa) that does not send push notifications to a user's devices if they have presence in any room. That is something to keep an eye out for.

Lastly, always worth getting the user to send an email via the "Support > Contact Us" flow. `PTKPushManager` should be well logged to console in the important places.


#### Potential improvements

- Coalescing notification acks. It shouldn't be crucial to acknowledge every single notification as it comes in. For example, if a chat starts in a room, and a message comes in every 5-10 seconds, then only the very first notification needs to be acknowledged immediately, whereas the following notifications (in some period of time, say 15 minutes) only need to be acked with a slightly longer grace period (say, 10-20 seconds?). Then, the iOS app only needs to fire off an HTTP request to the backend acknowledging notifications once every few seconds, instead of upon every single notification coming in. TL;DR; Instead of firing off 100 HTTP requests if 100 notifications come in <2 minutes, the app could instead group them and only fire them off every 10-20 seconds. This logic should be driven off an additional notification property determined by the backend (otherwise it should fire off acks immediately as it does currently).
- Do we actually need to fire an analytics event for recieving a push notification? If this information is not being used by any team, then it should be removed, as it is another source of a potential network request + processing that can keep the app awake longer than necessary.
- "Out-there" idea: instead of getting an ack from devices for every notification (which also only lets us know that the VOIP channel is up/down AFTER we try sending it...), what if instead we were constantly sending VOIP "pings" to every device? If we sent a VOIP ping to every user every 30 minutes, we would be able to tell if a user's device stopped being reachable via VOIP before we even try to send a notification. It also gives us valuable information about which users we know are directly and immediately reachable--if we ping a user's device and it successfully ACKs the notification, it means that that device is: 1) Turned On 2) Still has Signal installed 3) Will receive our push notifications. We now know that we have a direct channel of communication to these users.


#### Reference websites

- https://developer.apple.com/library/ios/documentation/Performance/Conceptual/EnergyGuide-iOS/OptimizeVoIP.html
- https://developer.apple.com/library/prerelease/ios/documentation/NetworkingInternet/Reference/PushKit_Framework/index.html
- https://developer.apple.com/videos/wwdc/2015/?id=720
