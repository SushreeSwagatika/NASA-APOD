//
//  NetworkMonitor.swift
//  WalE
//
//  Created by Sushree Swagatika on 26/03/23.
//

import Network
import UIKit


class NetworkMonitor: NSObject {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool {
        get { (status == .satisfied) }
        set {
            if newValue {
                print(newValue)
                
            }
        }
    }
    var isReachableOnCellular: Bool = true
    
    private override init() {
        super.init()
        self.startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .satisfied {
                print("We're connected!")
                // post notification
                NotificationCenter.default.post(name: .networkConnected, object: nil)
            } else {
                print("No connection.")
                // post notification
                NotificationCenter.default.post(name: .networkDisconnected, object: nil)
            }
            print(path.isExpensive)
        }
        
        let queue = DispatchQueue.main
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
