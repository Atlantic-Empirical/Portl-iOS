# Swift Research 

Swift is 👑! However it sometimes requires some extra attention in our very big Objective-C project.

## Using Swift in Objective-C code 
Add `#import "portkey-Swift.h"` to the .m-file. You can now acces all Swift classes that have a `@objc` prefix.

## Using Objective-C in Swift code 
Add the file that you want to use to `portkey-Bridging-Header.h`. Build the project. Afterwards you can access the classes in every swift file. Please remove files that are not used, this can cause compiler issues.. 
 
## Compiling issues
Sometimes issues occur when compiling with Swift files in the project. Cleaning the project is most of the time the best option. However, that takes very long and is horrible if you have to do that before every build & run. It slows down development. Note that when something doesn't build consistently on your computer: it'll probably fail CITests too.

Cleaning the project regenerates the object code. So the problem is lying somewhere in the object code (.o-files) that is compiled to later on. I think it must be something to do with the import of files

**Best working solutions**

* Make sure there's not more than two `@objc` enums described in one .swift-file. I haven't found the underlying reason why this solves the problem, but it works. 
* Don't import any .pch-files in `portkey-Birdging-Header.h` 
* Sort the imports in `portkey-Birdging-Header.h` in alphabetical order (weirdest fix ever)
* Remove unused imports from bridging headers

**Options that have been explored, but didn't really work:**

*I'm including these so that you don't have to try this again*

* Building without Defines Module set and then building again 
* Building a different target
* Cleaning derived data (this causes a re-index which takes as long as a clean)
* Changing the order of imports in the bridging header
* Removing the generated `portkey-Swift.h`
* Running `./up.sh` again

If something still isn't building, please send me (Sam) a message on slack. 

## Extensions

#### Localization
```swift
String.localize("Join room now")
```

## Styleguide & Best Practices

Unfortunately there's no general styleguide on every aspect of Swift. Let's follow this [Swift Styleguide](https://github.com/schwa/Swift-Community-Best-Practices) when possible and add the following things to it.

#### UITableViews and UICollectionViews 
Define reuse identifiers like this:

```swift 
	let scrollCellIdentifier = String(PTKTEDScrollCell)
```

#### Loging
For loging as a form of debugging. Use `debugPrint()`. A big advantage of this is that you can remove those afterwards, so they won't pollute the regular logs. 

#### Naming 
* protocols that are used by multiple objects and are not delegates/datasources must and with -able".

#### Folders
* protocols that are used by multiple objects and are not delegates/datasources must be places in the Protocols folder. 

#### Others
* never use x-align! it's good to read, but hard to maintain. 

## Logging 

This has nothing to do with Swift/Objective-C, but sometimes logging doesn't work when you run simulator. Force quitting the app inside the simulator and running it again solves this.