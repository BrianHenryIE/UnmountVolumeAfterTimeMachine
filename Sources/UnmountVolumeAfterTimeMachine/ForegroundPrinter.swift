//
// Created by Brian Henry on 6/24/23.
//

import BHSwiftOSLogStream
import Foundation

class ForegroudPrinter: LogStreamDelegateProtocol {

  init() {
    let stream = LogStream(process: "UnmountVolumeAfterTimeMachine", delegate: self, historySize: 1)
  }

  func newLogEntry(
    entry: BHSwiftOSLogStream.LogEntry,
    history: BHSwiftOSLogStream.History<BHSwiftOSLogStream.LogEntry>
  ) {
    print("fgp: \(entry.message)")
  }

}
