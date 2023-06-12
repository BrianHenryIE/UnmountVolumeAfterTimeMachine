# Unmount Volume After Time Machine

Automatically eject USB disks after Time Machine backup completes.

Originally requested as a feature for [nielsmouthaan/ejectify-macos](https://github.com/nielsmouthaan/ejectify-macos/issues/19) but not implemented by the developer.

Uses [BrianHenryIE/SwiftTimeMachine](https://github.com/BrianHenryIE/SwiftTimeMachine) and [BrianHenryIE/BHSwiftOSLogStream](https://github.com/BrianHenryIE/BHSwiftOSLogStream) to parse Time Machine logs and query `tmutil` for status. When the backup job completes, the disk is ejected with `DADiskUnmount`.

The fundamentals of this are working in this repo but it is far from finished.

Ideally:
* App should [run when disk plugged](https://apple.stackexchange.com/a/13724/299117) in / Time Machine starts and quit when the disk is ejected
* Disks should be re-mounted periodically
* Some sort of UI/checkbox to enable/disable/communicate the app is present and running
* [Notifications](https://github.com/dataJAR/Notifier) when the disk is ejected
