# XLogConsole

[![CI Status](https://img.shields.io/travis/Xing/XLogConsole.svg?style=flat)](https://travis-ci.org/Xing/XLogConsole)
[![Version](https://img.shields.io/cocoapods/v/XLogConsole.svg?style=flat)](https://cocoapods.org/pods/XLogConsole)
[![License](https://img.shields.io/cocoapods/l/XLogConsole.svg?style=flat)](https://cocoapods.org/pods/XLogConsole)
[![Platform](https://img.shields.io/cocoapods/p/XLogConsole.svg?style=flat)](https://cocoapods.org/pods/XLogConsole)



## introduce
Add a console print log to the app to facilitate troubleshooting

## Main function
- Support Minimized, full screen and landscape
- Support to extend the level, supports custom level color
- Support filter the log by level or name
- Support searching log by key
- Support to show the file and method names for the log
- Support get or export log at anytime

## How to use
### Simple code to use
It's easier to use Helper
1. `pod 'XLogConsole/Helper'`
2. `@import XLogConsole;` or `import XLogConsole`
3. And then use it directly
```
XLog(@"log content")// Used in OC
XLogWarn(@"log %@", @"warn")// Used in OC
XLog("log content")// Using in Swift
XLogWarn("log warn")// Using in Swift
```
### Customizations and extensions
Some custom property Settings are provided, most of them are not necessary and have default values
```
    let console = XLogConsole.shared
#if !DEBUG
    console.enable = false
#endif
    console.showLogNum = true
//    console.textAttributes = [.font: UIFont.boldSystemFont(ofSize: 16)]
//    console.timeAttributes = [.font: UIFont.italicSystemFont(ofSize: 16)]
//    console.logDetail = true
//    console.backgroundColor = .black
//    console.timeFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//    console.showConsoleAutomatically = true

```
`XLogLevel` can be extended freely, as shown in the Helper, we can simply wrap it up and then use it.
```
extension XLogLevel {
    public static let warn = XLogLevel(rawValue: "Warn", color: .orange)
    public static let error = XLogLevel(rawValue: "Error", color: .red)
}
XLogLevel.default.log("log default")
XLogLevel.warn.log("log warn", name: "mark1")
XLogLevel.error.log("log error", name: "mark2")
```

### Operation of the console
- Click the small icon to display or minimize the console
- When minimized, drag the icon to move it, and long press to hide it


## Release note
- 1.0.0 Initial release
- 1.0.1 Compatible windowScene project
- 1.0.2 Add a helper for direct use and invocation in OC
- 1.0.3 Fix bug
- 1.0.4 Add cache log file and fix bug

Some renderings

![](https://github.com/xing3523/Resources/raw/master/XLogConsole/demo1.png)
![](https://github.com/xing3523/Resources/raw/master/XLogConsole/demo2.png)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first. 

## Requirements
`iOS 10.0+`

## Installation
### CocoaPods

XLogConsole is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

1. Add `pod 'XLogConsole/Helper'` to the Podfile.
2. Execute `pod install` or `pod update`.

### Swift Package Manager Installation
Click Xcode's menu File > Swift Packages > Add Package Dependency, fill in `https://github.com/xing3523/XLogConsole`


## Author

Xing, xinxof@foxmail.com

## License

XLogConsole is available under the MIT license. See the LICENSE file for more info.
