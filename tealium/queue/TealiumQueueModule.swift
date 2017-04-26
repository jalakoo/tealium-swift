//
//  TealiumDatasourceModule.swift
//  SegueCatalog
//
//  Created by Jason Koo on 3/8/17.
//  Copyright © 2017 Apple, Inc. All rights reserved.
//

import Foundation
import SystemConfiguration

enum TealiumQueueKey {
    static let moduleName = "queue"
}

enum TealiumQueueConfigKey {
    static let disable = "queue_disable"
    static let queueSize = "queue_max_size"
}

enum TealiumQueueVariableKey {
    static let wasQueued = "was_queued"
}

enum TealiumQueueError : Error {
    case disabledByConfig
}

public protocol TealiumQueue : class {
    func tealiumShouldQueue(data: [String:Any]) -> Bool
    func tealiumDidQueue(data: [String:Any])
}

extension TealiumConfig {

    func disableQueue() {
        
        optionalData[TealiumQueueConfigKey.disable] = true
        
    }
    
    func setQueueSize(_ size : Int) {
        
        optionalData[TealiumQueueConfigKey.queueSize] = size

    }
    
}

class TealiumQueueModule : TealiumModule {
    
    var queue = [TealiumTrack]()
    var maxSize : Int = 100
    
    override func moduleConfig() -> TealiumModuleConfig {
        return TealiumModuleConfig(name: TealiumQueueKey.moduleName,
                                   priority: 950,
                                   build: 1,
                                   enabled: true)
    }
    
    override func enable(config: TealiumConfig) {
        
        if let disable = config.optionalData[TealiumQueueConfigKey.disable] as? Bool {
            if disable == true {
                let error = TealiumQueueError.disabledByConfig
                didFailToEnable(config: config,
                                error: error)
                return
            }
        }
        
        if let configMaxQueueSize = config.optionalData[TealiumQueueConfigKey.queueSize] as? Int {
            maxSize = configMaxQueueSize
        }
        
        // TODO: Load any saved tracks to the queue
        
        didFinishEnable(config: config)
    }
    
    override func track(_ track: TealiumTrack) {
        
        if isEnabled == false {
            // Forgo any queue module processing
            didFinishTrack(track)
            return
        }
        
        // Append data with was_queued data
        var wasQueuedValue : String = "false"
        let areOnline = isInternetAvailable()
        if areOnline == false {
            wasQueuedValue = "true"
        }
        var newData : [String:Any] = [TealiumQueueVariableKey.wasQueued: wasQueuedValue]
        newData += track.data
        let newTrack = TealiumTrack(data: newData,
                                    info: track.info,
                                    completion: track.completion)
        addToQueue(newTrack)
        
        if areOnline == false {
            // TODO: Reporting of queueing
            return
        }
        if queue.count > 0 {
            emptyQueue()
            return
        }
        
        didFinishTrack(newTrack)
    }
    
    func addToQueue(_ track: TealiumTrack) {
        
        // Limit queue size
        if queue.count >= maxSize {
            queue.removeFirst()
        }
        
        queue.append(track)
    }
    
    func emptyQueue() {
        
        for track in queue {
            didFinishTrack(track)
        }
        queue.removeAll()
        
    }
    
    func isInternetAvailable() -> Bool {
        // Credit to SO emraz
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }

    
}
