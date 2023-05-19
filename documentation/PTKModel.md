# PTKModel

`PTKModel` is our base model class. It is basically a `NSDictionary` on steroids, which means it's immutable, thread safe and automatically serializable.

## Why Immutable?

Basically, for thread safety. `NSMutableDictionary` (and mutable classes) are not thread safe. Since our data sources run in a background thread while interacting with delegates in the main thread, we need thread safety.

## OK, but I need to make some properties mutable!

Although the object itself is immutable, there are some helpers to create a copy by changing a value. Properties in `PTKModel` are defined by a method in the interface and a macro in the implementation. We have macros for several property types, like `MODEL_STRING` or `MODEL_DATE`, and each one also has a mutable variant, like `MODEL_STRING_MUTABLE`. The mutable variants expect a method with the signature `- (id)methodName:(type)value`, and will return a copy of the original object by setting the property to the defined value. Keep in mind that since it's a copy, if you're changing the object in a data source you'll need to update the data source with the new object. Please check the current `PTKModel` subclasses for examples on how to use this.

You can also add mutable properties to a `PTKModel` subclass. However, treat those as a `cache`, since they're not persisted when the object is serialized/deserialized. They're useful when you just need to make a small and temporary change in a specific object.

## Why methods instead of properties?

There are a couple reasons. First, this makes it clear that you can't actually change the value (sometimes you might create a `@property` and forget to set `readonly`, and that will give you a lot of headache in the future). Also, Xcode will complain if you define a method and don't pair with a valid macro in the implementation. If it was a property, it would not complain, you'd think everything was working but actually the class would just automatically synthesize the property as a normal value.

## The mutability helpers are too complicated to implement!

This is kinda intentional. Making a mutable property in a `PTKModel` subclass has implications, so by being harder to implement will make us use it only when really needed.

#Usage

## Adding a Property

Start by adding a method to the header file, like this:

```
- (NSString *)title;
```

Then add a macro to the implementation file, like this:

```
MODEL_STRING(title, @"title", nil)
```

The parameters in the macro are: method name, storage key in the dictionary, and default value.

## Adding a Mutable Property

Start by adding two methods to the header file, like this:

```
- (NSString *)title;
- (id)copyWithTitle:(NSString *)title;
```

Then add a macro to the implementation file, like this:

```
MODEL_STRING_MUTABLE(title, copyWithTitle, @"title", nil)
```

The parameters in the macro are: method name, set method name, storage key in the dictionary, and default value. When updating the value, you can use it like this:

```
PTKRoom *oldRoom = [[PTKWeakSharingManager roomsDataSource] objectWithId:roomId];
PTKRoom *newRoom = [oldRoom copyWithTitle:@"New Title"];
[[PTKWeakSharingManager roomsDataSource] sortAndAddObject:newRoom];
```

Also, `PTKModel` has a method with the signature `- (void)updateLocalPropertiesFromModel:(PTKModel *)oldModel`. Implement this method in your subclass to update local property values when your object is copied.

# Available Property Types

- `MODEL_STRING(getterName, storageName, defValue)` - `NSString`
- `MODEL_DATE(getterName, storageName, defValue)` - `NSDate`
- `MODEL_BOOL(getterName, storageName, defValue)` - `BOOL`
- `MODEL_INT(getterName, storageName, defValue)` - `int`
- `MODEL_NSINTEGER(getterName, storageName, defValue)` - `NSInteger`
- `MODEL_NSUINTEGER(getterName, storageName, defValue)` - `NSUInteger`
- `MODEL_FLOAT(getterName, storageName, defValue)` - `float`
- `MODEL_DOUBLE(getterName, storageName, defValue)` - `double`
- `MODEL_TIMEINTERVAL(getterName, storageName, defValue)` - `NSTimeInterval`
- `MODEL_DICTIONARY(getterName, storageName, defValue)` - `NSDictionary`
- `MODEL_ARRAY(getterName, storageName, typeName)` - `NSArray`
- `MODEL_SUBPROPERTY(getterName, storageName, type)` - `PTKModel` subclass

All property types have a similar macro with the `_MUTABLE` suffix.
