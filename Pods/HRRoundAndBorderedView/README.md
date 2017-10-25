# HRRoundAndBorderedView

[![Version](https://img.shields.io/cocoapods/v/HRRoundAndBorderedView.svg?style=flat)](http://cocoapods.org/pods/HRRoundAndBorderedView)
[![License](https://img.shields.io/cocoapods/l/HRRoundAndBorderedView.svg?style=flat)](http://cocoapods.org/pods/HRRoundAndBorderedView)
[![Platform](https://img.shields.io/cocoapods/p/HRRoundAndBorderedView.svg?style=flat)](http://cocoapods.org/pods/HRRoundAndBorderedView)

UIView category for update view's layer properties: borderColor, borderWidth and cornerRadius. Also can be changed from Interface Builder 'cause properties is IBInspectable.

## Usage

Change this properties programmatically or in Interface Buider.

```objective-c
@property (nonatomic, strong, nonnull) IBInspectable UIColor *hrBorderColor;
@property (nonatomic) IBInspectable CGFloat hrBorderWidth;
@property (nonatomic) IBInspectable CGFloat hrCornerRadius;
```

Also, u can try this pod by 1 line:

```ruby
pod try "HRRoundAndBorderedView"
```

## Requirements

iOS 8.0 or greater.

## Installation

HRRoundAndBorderedView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HRRoundAndBorderedView"
```

## Author

Ivan Shevelev, vanujkee@icloud.com

## License

HRRoundAndBorderedView is available under the MIT license. See the LICENSE file for more info.
