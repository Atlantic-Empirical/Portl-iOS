### Possibilities 
`PTKAlertViewController` can display an alert that has a title and a description. It supports attributed strings (use the initializer that has `attributedString`). 

You can add an image or emoji to the top of the box by initializing it with an `icon` or `emoji` property. 

You can add up to three actions to the alert, they will be displayed as buttons just like Apple's UIAlertView. We use autolayout for that. 


### Examples
__objective-c 👴__

```objective-c
PTKAlertViewController *alert = [[PTKAlertViewController alloc] initWithEmoji:@"🎉" title:@"Usernames Have Arrived" description:@"People can find you on Airtime by username, Claim yours while it's still available"];
PTKAlertAction *skip = [[PTKAlertAction alloc] initWithTitle:@"Skip" style:UIAlertActionStyleCancel handler: ^{
    [alert dismiss];
    // skip code
}];
PTKAlertAction *claim = [[PTKAlertAction alloc] initWithTitle:@"Claim" style:UIAlertActionStyleDefault handler: ^{
    // claim code
}];
alert.actions = @[skip, claim];
[self.navigationController presentViewController:alert animated:YES completion:nil];
```

__swift 👶__

```swift 
let alert = PTKAlertViewController(emoji: "👅", title: "Usernames Have Arrived", description: "People can find you on Airtime by username, Claim yours while it's still available")
let skip = PTKAlertAction(title: "Skip", style: .Cancel, handler: {
    alert.dismiss()
    // skip code
})
let claim = PTKAlertAction(title: "Claim", style: .Default, handler: {
    // claim code
})
alert.actions = [skip, claim]

```

### Why?

__This was in Apples documentation:__

_Subclassing Notes The UIAlertController class is intended to be used as-is and does not support subclassing. The view hierarchy for this class is private and must not be modified._

Therefore I chose to not subclass their class and make my own. 

Also, I had to develop `PTKAlertAction` our own version of `UIAlertAction` because we can't access its handler.
I did choose to use the standard `UIAlertActionStyle` enum:

```swift
public enum UIAlertActionStyle : Int {
    case Default
    case Cancel
    case Destructive
}
```

### Future
* Add animations 
* When we move off iOS 8, I'd like to use a UIStackView for the buttons, this would allow us to have an unlimited number of buttons. 