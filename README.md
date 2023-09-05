# Unmount Volume After Time Machine

Automatically eject USB disks after Time Machine backup completes.

Launches when a USB disk is inserted and exits after Time Machine completes.

To avoid:

![disk-not-ejected-properly.png](disk-not-ejected-properly.png)

Quickly install via [yonaskolb/Mint](https://github.com/yonaskolb/Mint) – _A package manager that installs and runs Swift command line tool packages._
```
brew install mint
mint run BrianHenryIE/UnmountVolumeAfterTimeMachine
```

![Background Items Added.png](Background%20Items%20Added.png)

```
mint uninstall BrianHenryIE/UnmountVolumeAfterTimeMachine 
```

***

Originally requested as a feature for [nielsmouthaan/ejectify-macos](https://github.com/nielsmouthaan/ejectify-macos/issues/19) but not implemented in that project.

Uses [BrianHenryIE/SwiftTimeMachine](https://github.com/BrianHenryIE/SwiftTimeMachine) and [BrianHenryIE/BHSwiftOSLogStream](https://github.com/BrianHenryIE/BHSwiftOSLogStream) to parse Time Machine logs and query `tmutil` for status. When the backup job completes, the disk is ejected with `DADiskUnmount`.

~~The fundamentals of this are working in this repo~~ The app is working! but it is far from finished.


TODO:
* ~~App should [run when disk plugged](https://apple.stackexchange.com/a/13724/299117) in / Time Machine starts and quit when the disk is ejected~~ [emorydunn/LaunchAgent](https://github.com/emorydunn/LaunchAgent)
* ~~When the app launches upon a disk being inserted, it should exit quickly if the disk is not used for Time Machine~~
* What happens the app tries to unmount after Time Machine but other files are being copied in Finder?
* Disks should be re-mounted as per the Time Machine schedule
* Some sort of UI/checkbox to enable/disable/communicate the app is present and running [apple/swift-argument-parser](https://github.com/apple/swift-argument-parser)
* [Notifications](https://github.com/dataJAR/Notifier) when the disk is ejected
* ~~Make available via [brew](https://docs.brew.sh/Formula-Cookbook)~~
* Currently, a race condition is possible that would cause the app to exit after another disk was unmounted (tiny window, fraction of a second)
* Check is the app already running

https://blog.eidinger.info/develop-a-command-line-tool-using-swift-concurrency


```
mint uninstall BrianHenryIE/UnmountVolumeAfterTimeMachine 
```
Asking permission to use notifications
https://developer.apple.com/documentation/usernotifications/asking_permission_to_use_notifications
How can I write to Notification Center from a launchd command?
https://apple.stackexchange.com/questions/63117/how-can-i-write-to-notification-center-from-a-launchd-command
UNUserNotificationCenter
https://developer.apple.com/documentation/usernotifications/unusernotificationcenter
How to set local alerts using UNNotificationCenter
https://www.hackingwithswift.com/example-code/system/how-to-set-local-alerts-using-unnotificationcenter
UNUserNotificationCenter not working locally
https://developer.apple.com/forums/thread/53390
iOS 11 crashing with bundleProxy != nil error on using UNUserNotificationCenter
https://stackoverflow.com/questions/46595434/ios-11-crashing-with-bundleproxy-nil-error-on-using-unusernotificationcenter
Mac Mountain Lion send notification from CLI app
https://stackoverflow.com/questions/11712535/mac-mountain-lion-send-notification-from-cli-app
Demonstrate how to post NSUserNotification from CLI(without Application Bundle) on OS X 10.8.
https://github.com/norio-nomura/usernotification
Using the New UNUserNotification API in a Standalone Objective-C Program
https://stackoverflow.com/questions/70808394/using-the-new-unusernotification-api-in-a-standalone-objective-c-program
Local User Notifications with UNUserNotificationCenter
https://www.appsdeveloperblog.com/local-user-notifications-with-unusernotificationcenter/

Build and run
```
swift build -c release
./.build/release/UnmountVolumeAfterTimeMachine
```