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
        print("about to unmount \(volume)")

//        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(diskUnmounted), name: NSWorkspace.didUnmountNotification, object: nil)

        guard let session = DASessionCreate(kCFAllocatorDefault) else { return }

        let diskUrls = FileManager.default.mountedVolumeURLs(includingResourceValuesForKeys: nil)

        let volumePathMather = "file://\(volume)/"

        print("Try to match \(volumePathMather)")

        diskUrls?.forEach({

            print( $0.absoluteString )

            if  volumePathMather == $0.absoluteString {

                print( "match" )

                guard let disk: DADisk = DADiskCreateFromVolumePath(kCFAllocatorDefault, session, $0 as CFURL) else {
                    print("Failed to get DADisk")
                    return
                }

                DADiskUnmount(disk, DADiskUnmountOptions(kDADiskUnmountOptionDefault), { _, _, _ in
                    print("should now be unmounted")
                }, nil)

            }

        })

    }
}
