### Lightning Fast Messages

See https://github.com/airtimemedia/palpatine/blob/develop/docs/Socket-Messaging.md

Take a look at `-doTask:` in `PTKMessageSender.m`. The relevant bit of code:

```objective-c
if ([self shouldSendTaskViaPalpatine]) {
    [self sendTaskViaPalpatine:task withCallback:callback];
} else {
    [self sendTaskViaDeathstar:task withCallback:callback];
}
```

`-shouldSendTaskViaPalpatine` currently checks to see if:
- The socket is connected and "healthy"
- AND if no lightning-fast messages have failed in the last 4 minutes

