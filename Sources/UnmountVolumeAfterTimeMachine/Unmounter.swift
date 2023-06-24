//
//  Unmounter.swift
//  UnmountVolumeAfterTimeMachine
//
//  Created by Brian Henry on 2/25/23.
//
// https://stackoverflow.com/questions/1408216/detect-when-removable-storage-is-unmounted?rq=4

import Foundation
import SwiftTimeMachine
import OSLog
import AppKit

class Unmounter {

    func unmount(volume: String) {
        os_log( "about to unmount %{public}@", log: .default, type: .info, volume )

        guard let session = DASessionCreate(kCFAllocatorDefault) else { return }

        let diskUrls = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil)

        guard let urlEncodedVolume = volume.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        let volumePathMatcher = "file://\(urlEncodedVolume)/"

        os_log( "Try to match %{public}@", log: .default, type: .info, volumePathMatcher )

        diskUrls?.forEach({
            os_log( "Disk: %{public}@", log: .default, type: .info, $0.absoluteString )

            if volumePathMatcher == $0.absoluteString {

                os_log( "match" )

                guard let disk: DADisk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, $0 as CFURL) else {
                    os_log("Failed to get DADisk")
                    return
                }

                // Listen for the `didUnmountNotification`.
                NSWorkspace.shared.notificationCenter.addObserver(
                        self,
                        selector: #selector(unmounted),
                        name: NSWorkspace.didUnmountNotification,
                        object: nil
                )

                // What if something other than time machine was using it?!
                DADiskUnmount(disk, DADiskUnmountOptions(kDADiskUnmountOptionDefault), { _, _, _ in
                    os_log("should now be unmounted")
                }, nil)
            }
        })
    }

    // `.didUnmountNotification`
    @objc func unmounted() {
        os_log("volume has been unmounted, exiting")
        exit(0)
    }
}
