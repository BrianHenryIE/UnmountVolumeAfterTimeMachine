//
//
//

import OSLog

@main
public struct UnmountVolumeAfterTimeMachine {
    public private(set) var text = "Hello, World!"

    static var notificationListener: TimeMachineNotificationListener? = nil

    public static func main() {
        os_log( "%{public}@", log: .default, type: .info, UnmountVolumeAfterTimeMachine().text )

        notificationListener = TimeMachineNotificationListener()

        print("before")

        // How to close when finished?!!
        RunLoop.current.run()

        print("after")
    }
}
