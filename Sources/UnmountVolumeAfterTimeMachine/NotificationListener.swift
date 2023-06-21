//
// Created by Brian Henry on 6/9/23.
//
// TODO: It always starts with "Could not parse line:"
//

import Foundation
import SwiftTimeMachine
import BHSwiftOSLogStream

class NotificationListener {

    let unmounter: Unmounter

    init(unmounter: Unmounter) {

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

        guard let timeMachineLog = notification.object as? TimeMachineLog else {return}

        print( "new TimeMachine notification received")

        guard let newLog: LogEntry = timeMachineLog.previousInfoLogs.get() else {
            return
        }

        print( "TimeMachine notification message: \(newLog.message)" )

        print( "Pausing 10 seconds" )

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {

            let tmUtil = TmUtil()

            // Maybe add a momentary delay here

            guard let status: TmStatus = tmUtil.status() else {
                print("failed to get tmUtil.status()")
                return
            }

            print("Time machine is\(status.running ? "" : " not") currently running.")

            guard let destinationInfo = tmUtil.destinationInfo() else {
                print( "failed to get tmUtil.destinationInfo() ")
                return
            }

            // Filter here to local mount points

            guard let destinationMountPoint = destinationInfo.destinations.first?.mountPoint else {
                print("failed to get destinationInfo.destinations.first?.mountPoint")
                return
            }

            if false == status.running {
                self.unmounter.unmount(volume: destinationMountPoint)
            }
        }
    }
}
