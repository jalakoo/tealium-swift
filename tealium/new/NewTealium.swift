//
//  TealiumNewModulesManager.swift
//  tealium-swift
//
//  Created by Jason Koo on 1/30/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

class NewTealium {
    
    var config: TealiumConfig?
    var modules: [TealiumAsyncTask]
    
    public init() {
        // TODO: Dynamically load
        self.modules = [
            SampleTealiumModule.new()
        ]
    }
    
    // No longer necessary
    public func update(config: TealiumConfig) {
        self.enable(config)
    }
    
    public func enable(_ config:TealiumConfig) {
        self.config = config
        let request = TealiumEnableRequest(config: config)
        modules.runTealiumAsyncTasks(request: request)
    }
    
    public func disable() {
        let request = TealiumDisableRequest()
        modules.runTealiumAsyncTasks(request: request)
    }
    
    public func track(title: String) {
        self.track(title: title,
                   data: nil,
                   completion: nil)
    }

    public func track(title: String,
                      data: [String:Any]?,
                      completion: TealiumCompletion?) {
        let trackData = Tealium.trackDataFor(title: title,
                                             optionalData: data)
        let request = TealiumTrackRequest(data: trackData,
                                          completion: completion)
        modules.runTealiumAsyncTasks(request: request)
    }
    
    public func trackView(title: String,
                          data: [String:Any]?,
                          completion: TealiumCompletion?) {
        let trackData = Tealium.trackDataFor(title: title,
                                             optionalData: data)
        let request = TealiumTrackRequest(data: trackData,
                                          completion: completion)
        modules.runTealiumAsyncTasks(request: request)
    }
    
}


