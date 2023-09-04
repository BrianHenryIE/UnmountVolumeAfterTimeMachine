//
// Created by Brian Henry on 6/9/23.
//
// TODO: It always starts with "Could not parse line:"
//

import BHSwiftOSLogStream
import Foundation
import OSLog
import SwiftTimeMachine

class TimeMachineNotificationListener {

  let unmounter: Unmounter

  init(unmounter: Unmounter = Unmounter()) {

    self.unmounter = unmounter

    TimeMachineLog.shared.addObserver(
      self,
      selector: #selector(unmountVolume),
      name: Notification.Name.TimeMachineLogAfterThinning,
      object: nil
    )

    TimeMachineLog.shared.addObserver(
      self,
      selector: #selector(unmountVolume),
      name: Notification.Name.TimeMachineLogAfterCompletedBackup,
      object: nil
    )

    TimeMachineLog.shared.addObserver(
      self,
      selector: #selector(unmountVolume),
      name: Notification.Name.TimeMachineLogAfterCompletedBackupNoThinning,
      object: nil
    )
  }

  @objc func unmountVolume(notification: Notification) {

    guard let timeMachineLog = notification.object as? TimeMachineLog else {
      return
    }

    os_log("new TimeMachine notification received")

    guard let newLog: LogEntry = timeMachineLog.previousInfoLogs.get() else {
      return
    }

    os_log("TimeMachine notification message: %public%@", newLog.message)

    os_log("Pausing 10 seconds")

    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {

      let tmUtil = TmUtil()

      if tmUtil.status()?.running != false {
        os_log("failed to confirm backup is not still running (via tmUtil.status())")
        return
      }

      guard let destinationInfo = tmUtil.destinationInfo() else {
        os_log("failed to get tmUtil.destinationInfo() ")
        return
      }

      // Filter to only local destinations.
      // TODO: This should really be captured from the notification, not guessed from tmutil.
      let localDestinations = destinationInfo.destinations.filter { $0.kind == .local }

      guard let destinationMountPoint = localDestinations.first?.mountPoint else {
        os_log("failed to get destinationInfo.destinations.first?.mountPoint")
        return
      }

      self.unmounter.unmount(volume: destinationMountPoint)
    }
  }
}
