//
//  NewTealiumModule.swift
//  ios
//
//  Created by Jason Koo on 1/31/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

class NewTealiumModule {
    
    static var module: NewTealiumModule?
    
    class func new() -> TealiumAsyncTask {
        return { (request:TealiumRequest?, taskCompletion: @escaping TealiumAsyncTaskCompletion) in
            
            if module == nil {
                module = self.init(onEnabled: { (success, info, error) in
                    taskCompletion(request)
                }, onDisabled: { (success, info, error) in
                    taskCompletion(request)
                }, onTracked: { (success, info, error) in
                    taskCompletion(request)
                })
            }
            
            if let enable = request as? TealiumEnableRequest {
                module?.enable(enable)
                return
            }
            
            if let disable = request as? TealiumDisableRequest {
                module?.disable(disable)
                return
            }
            
            if let track = request as? TealiumTrackRequest {
                module?.track(track)
                return
            }
            
            // Default pass to next module
            taskCompletion(request)
            
        }
    }
    
    var finishedEnabling: TealiumCompletion
    var finishedDisabling: TealiumCompletion
    var finishedTracking: TealiumCompletion
    
    required init(onEnabled: @escaping TealiumCompletion,
                  onDisabled: @escaping TealiumCompletion,
                  onTracked: @escaping TealiumCompletion) {
        finishedEnabling = onEnabled
        finishedDisabling = onDisabled
        finishedTracking = onTracked
    }
    
    // Default methods - all subclassable
    
    func enable(_ request: TealiumEnableRequest) {
        finishedEnabling(true, nil, nil)
    }
    
    func disable(_ request: TealiumDisableRequest) {
        finishedDisabling(true, nil, nil)
    }
    
    func track(_ request: TealiumTrackRequest) {
        finishedTracking(true, nil, nil)
    }
    
    func onEnabled(completion: @escaping TealiumCompletion) {
        finishedEnabling = completion
    }
    
    func onDisabled(completion: @escaping TealiumCompletion) {
        finishedDisabling = completion
    }
    
    func onTracked(completion: @escaping TealiumCompletion) {
        finishedTracking = completion
    }
    
}
