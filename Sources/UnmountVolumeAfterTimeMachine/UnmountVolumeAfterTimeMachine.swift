//
//
//

import OSLog

@main
public struct UnmountVolumeAfterTimeMachine {
    public private(set) var text = "Hello, World!"

    static var notificationListener: NotificationListener? = nil

    public static func main() {
        os_log( "%{public}@", log: .default, type: .info, UnmountVolumeAfterTimeMachine().text )

        let unmounter = Unmounter()
        notificationListener = NotificationListener(unmounter: unmounter)

        print("before")

        // How to close when finished?!!
        RunLoop.current.run()

        print("after")
    }
}
