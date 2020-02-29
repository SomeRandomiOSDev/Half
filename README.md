Half
========

[![License MIT](https://img.shields.io/cocoapods/l/Half.svg)](https://cocoapods.org/pods/Half)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Half.svg)](https://cocoapods.org/pods/Half) 
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) 
[![Platform](https://img.shields.io/cocoapods/p/Half.svg)](https://cocoapods.org/pods/Half)
![Linux](https://img.shields.io/badge/platform-linux-lightgrey)
[![Build](https://travis-ci.com/SomeRandomiOSDev/Half.svg?branch=master)](https://travis-ci.com/SomeRandomiOSDev/Half)
[![Code Coverage](https://codecov.io/gh/SomeRandomiOSDev/Half/branch/master/graph/badge.svg)](https://codecov.io/gh/SomeRandomiOSDev/Half)
[![Codacy](https://api.codacy.com/project/badge/Grade/8ad52c117e4a46d9aa4699d22fc0bf49)](https://app.codacy.com/app/SomeRandomiOSDev/Half?utm_source=github.com&utm_medium=referral&utm_content=SomeRandomiOSDev/Half&utm_campaign=Badge_Grade_Dashboard)
![Test](https://github.com/SomeRandomiOSDev/Half/workflows/Test/badge.svg)

**Half** is a lightweight framework containing a Swift implementation for a half-precision floating point type for iOS, macOS, tvOS, and watchOS.

Installation
--------

**Half** is available through [CocoaPods](https://cocoapods.org), [Carthage](https://github.com/Carthage/Carthage) and the [Swift Package Manager](https://swift.org/package-manager/). 

To install via CocoaPods, simply add the following line to your Podfile:

```ruby
pod 'Half'
```

To install via Carthage, simply add the following line to your Cartfile:

```ruby
github "SomeRandomiOSDev/Half"
```

To install via the Swift Package Manager add the following line to your `Package.swift` file's `dependencies`:

```swift
.package(url: "https://github.com/SomeRandomiOSDev/Half.git", from: "1.0.0")
```

Usage
--------

First import **Half** at the top of your Swift file:

```swift
import Half
```

After importing, use the imported `Half` type excatly like you'd use Swift's builtin `Float`, `Double`, or `Float80` types. 

```swift
let value: Half = 7.891
let squareRoot = sqrt(value)

...
```

TODO
--------

* Add support for SIMD functions & types with half-precision

Contributing
--------

If you have need for a specific feature or you encounter a bug, please open an issue. If you extend the functionality of **Half** yourself or you feel like fixing a bug yourself, please submit a pull request.

Author
--------

Joseph Newton, somerandomiosdev@gmail.com

Credits
--------

**Half** is based heavily on the implementations of the `Float`, `Double`, and `Float80` structures provided by Swift. See `ATTRIBUTIONS` for more details. 

License
--------

**Half** is available under the MIT license. See the `LICENSE` file for more info.
