//
//  Network.swift
//  WorldOfPAYBACK
//
//  Created by Samrez Ikram on 11/02/2023.
//

import Foundation
import Network

class Network {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    static var isConnected: Bool = false
    static let shared = Network()
    init() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                Network.isConnected = path.status == .satisfied ? true : false
            }
        }
        monitor.start(queue: queue)
    }
}
