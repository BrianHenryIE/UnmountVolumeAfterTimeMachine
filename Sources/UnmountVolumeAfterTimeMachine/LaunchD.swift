//
// Created by Brian Henry on 6/24/23.
//

import Foundation
import OSLog

// ~/.mint/packages/github.com_BrianHenryIE_UnmountVolumeAfterTimeMachine/build/master/UnmountVolumeAfterTimeMachine

// If launchd file exists, validate it
// if it does not exist create it

// load and unload options

import LaunchAgent

struct LaunchD {

    init?() {

        guard let programPath = Bundle.main.executablePath else {
            os_log( "Failed to get app path from Bundle")
            return
        }

let domain = "ie.BrianHenry.UnmountVolumeAfterTimeMachine"
        var agent: LaunchAgent?
        agent = try? LaunchControl.shared.read(agent: domain)
        if agent != nil {
            os_log("launchd agent already set")
            print("launchd agent already set")
        } else {
            print("No launchd agent set")
            os_log("No launchd agent set")
            agent = LaunchAgent(
                    label: domain,
                    program: [programPath]
            )
            do {
                try LaunchControl.shared.write(agent!)

                print("launchd agent written")
                os_log("launchd agent written")
            } catch {
                print("Unexpected written error: \(error.localizedDescription)")
                os_log("Unexpected written error: \(error.localizedDescription)")
            }

        }
        guard let agent = agent else {
            print("Failed to create launchd agent")
            os_log("Failed to create launchd agent")
            return
        }

        // Make sure it's configured to startOnMount
        if agent.startOnMount != true {
            agent.startOnMount = true
            do {
                try LaunchControl.shared.write(agent)
//                try agent.bootstrap()

                print("launchd agent startOnMount set")
                os_log("launchd agent startOnMount set")
            } catch {
                print("Unexpected startOnMount error: \(error.localizedDescription)")
                os_log("Unexpected startOnMount error: \(error.localizedDescription)")
            }
        }

        // If the launch agent was configured from another instance of the app, e.g. one is already installed and
        // this an updated version.
        if agent.program != programPath {
            print("Updating agent program path from \(agent.program ?? "empty") to \(programPath)")
            os_log("Updating agent program path from \(agent.program ?? "empty") to \(programPath)")
            agent.program = programPath
            do {
                try LaunchControl.shared.write(agent)
//                try agent.bootstrap()
            } catch {
                print("Unexpected programPath boostrap error: \(error.localizedDescription)")
                os_log("Unexpected programPath boostrap error: \(error.localizedDescription)")
            }
        }

        print( "status: \(agent.status())" )
        os_log( "status: %public%@", "\(agent.status())" )

        // To stop it running, but leave the plist in place `agent.stop()`
        // To remove it: try `agent.bootout()`
    }

}
