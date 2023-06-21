@main
public struct UnmountVolumeAfterTimeMachine {
    public private(set) var text = "Hello, World!"

    static var notificationListener: NotificationListener? = nil

    public static func main() {
        print(UnmountVolumeAfterTimeMachine().text)

        let unmounter = Unmounter()
        notificationListener = NotificationListener(unmounter: unmounter)
    }
}
