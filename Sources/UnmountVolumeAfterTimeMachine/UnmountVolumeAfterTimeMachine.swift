//
//
//

import OSLog
import SwiftTimeMachine


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
    let keys = [
      URLResourceKey.volumeNameKey, URLResourceKey.volumeIsRemovableKey,
      URLResourceKey.volumeIsEjectableKey,
    ]
    let paths = FileManager.default.mountedVolumeURLs(
      includingResourceValuesForKeys: keys, options: [])
    guard let paths = paths, !paths.isEmpty else {
      // There are not mounted volumes
      return
    }

    // Get all Time Machine destinations
    let tmUtil = TmUtil()
    guard
      let tmDestinationMountPointsM = tmUtil.destinationInfo()?.destinations.map({ $0.mountPoint })
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
