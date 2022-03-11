//
//  MetricsViewModel.swift
//  NewRelic
//
//  Copyright © 2022 newrelicchallenge. All rights reserved.
//

import Foundation

struct MetricsViewModel {

    private let networkResponseTimes: [TimeInterval]

    init(networkResponseTimes: [TimeInterval]) {
        self.networkResponseTimes = networkResponseTimes
    }

    func modelIdentifier() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine,
                                  count: Int(_SYS_NAMELEN)),
                      encoding: .ascii)!
            .trimmingCharacters(in: .controlCharacters)
    }

    func networkDidTimeout() -> Bool {
        networkResponseTimes.isEmpty
    }

    func averageNetworkResponseTime() -> TimeInterval {
       networkResponseTimes.reduce(0, +) / Double(networkResponseTimes.count)
    }

    func numberOfMetrics() -> Int {
        return 3
    }


}
