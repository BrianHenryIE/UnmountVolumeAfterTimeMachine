//
// Created by Brian Henry on 6/9/23.
//
// TODO: It always starts with "Could not parse line:"
//

import Foundation
import SwiftTimeMachine
import BHSwiftOSLogStream
import OSLog

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

        os_log( "new TimeMachine notification received")

        guard let newLog: LogEntry = timeMachineLog.previousInfoLogs.get() else {
            return
        }

        os_log( "TimeMachine notification message: \(newLog.message)" )

        os_log( "Pausing 10 seconds" )

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {

            let tmUtil = TmUtil()

            guard let status: TmStatus = tmUtil.status() else {
                os_log("failed to get tmUtil.status()")
                return
            }

            os_log( "Time machine is %{public}@ currently running.", log: .default, type: .info, status.running ? "" : " not" )

            guard let destinationInfo = tmUtil.destinationInfo() else {
                os_log( "failed to get tmUtil.destinationInfo() ")
                return
            }

            // Filter here to local mount points

            guard let destinationMountPoint = destinationInfo.destinations.first?.mountPoint else {
                os_log("failed to get destinationInfo.destinations.first?.mountPoint")
                return
            }

            if false == status.running {
                self.unmounter.unmount(volume: destinationMountPoint)
            }
        }
    }
}
