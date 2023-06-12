//
//  UnmountVolumeAfterTimeMachineApp.swift
//  UnmountVolumeAfterTimeMachine
//
//  Created by Brian Henry on 2/25/23.
//
//

import SwiftUI

@main
struct UnmountVolumeAfterTimeMachineApp: App {

    let notificationListener: NotificationListener

    init() {
        let unmounter = Unmounter()
        notificationListener = NotificationListener(unmounter: unmounter)
    }

    var body: some Scene {

        return WindowGroup {
            ContentView()
        }
    }
}
