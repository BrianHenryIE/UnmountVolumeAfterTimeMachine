//
//
//

import OSLog
import SwiftTimeMachine

// Should have --enable to add launchd, --disable to delete launchd, --background to start in bg
// Instruction oh how to uninstall
// Each start should print whether launchd is set up

// Add a ESC keyboard listener to quit
// Exit if run in foreground, with instruction on how ot tail logs

@main
public struct UnmountVolumeAfterTimeMachine {
  public private(set) var text = "UnmountVolumeAfterTimeMachine started!"

  static var notificationListener: TimeMachineNotificationListener?

  public static func main() {

    _ = LaunchD()

    // TODO: Conditionally load this when the app is run from the command line, but not launchd.
    //        _ = ForegroudPrinter()

    os_log("%{public}@", log: .default, type: .info, UnmountVolumeAfterTimeMachine().text)

    // Get all volumes
    guard let paths = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil),
      !paths.isEmpty
    else {
      // There are no mounted volumes
      return
    }

    // Get all Time Machine destinations
    guard
      let tmDestinationMountPointsM = TmUtil().destinationInfo()?.destinations
        .map({ $0.mountPoint })
    else {
      // Print ~ "there are no time machine destinations configured"
      return
    }
    // remove nil values
    let tmDestinationMountPoints = tmDestinationMountPointsM.compactMap({ $0 })

    // Check all mounted volumes to see are they a Time Machine destination
    let activeTmVolumes = paths.filter { (mountedVolume: URL) in
      let path = mountedVolume.path
      if path == "/" {
        return false
      }
      return tmDestinationMountPoints.reduce(
        false,
        { (ret: Bool, tmVolume: String) in
          // Is the mounted volume a TM volume.
          ret || tmVolume.contains(path)
        })
    }

    // If no mounted volumes are relevant to Time Machine, just exit.
    if 0 == activeTmVolumes.count {
      return
    }

    notificationListener = TimeMachineNotificationListener()

    // Stay alive until the disk is unmounted.
    RunLoop.current.run()
  }
}
