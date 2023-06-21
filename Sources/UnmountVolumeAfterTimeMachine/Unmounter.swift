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

//        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(diskUnmounted), name: NSWorkspace.didUnmountNotification, object: nil)

        guard let session = DASessionCreate(kCFAllocatorDefault) else { return }

        let diskUrls = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil)

        let volumePathMather = "file://\(volume)/"

        os_log( "Try to match %{public}@", log: .default, type: .info, volumePathMather )

        diskUrls?.forEach({
            os_log( "%{public}@", log: .default, type: .info, $0.absoluteString )

            if  volumePathMather == $0.absoluteString {

                os_log( "match" )

                guard let disk: DADisk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, $0 as CFURL) else {
                    os_log("Failed to get DADisk")
                    return
                }

                DADiskUnmount(disk, DADiskUnmountOptions(kDADiskUnmountOptionDefault), { _, _, _ in
                    os_log("should now be unmounted")
                }, nil)
            }
        })
    }
}
