//
//
//

import OSLog

@main
public struct UnmountVolumeAfterTimeMachine {
    public private(set) var text = "Hello, World!"

    static var notificationListener: TimeMachineNotificationListener? = nil

    public static func main() {

        _ = LaunchD()

        // TODO: Conditionally load this when the app is run from the command line, but not launchd.
//        _ = ForegroudPrinter()

        os_log( "%{public}@", log: .default, type: .info, UnmountVolumeAfterTimeMachine().text )

        notificationListener = TimeMachineNotificationListener()

        // Stay alive until the disk is unmounted.
        RunLoop.current.run()
    }
}
