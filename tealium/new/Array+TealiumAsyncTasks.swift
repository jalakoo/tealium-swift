//
//  Array+TealiumAsyncTasks.swift
//  tealium-swift
//
//  Created by Jason Koo on 1/30/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

typealias TealiumAsyncTask = (_ request: TealiumRequest?, _ completion: @escaping TealiumAsyncTaskCompletion)->()
typealias TealiumAsyncTaskCompletion = (_ request: TealiumRequest?)->()

struct TealiumInfo {
    let config: TealiumConfig
    let request: TealiumRequest
}

extension Array {
    
    func runTealiumAsyncTasks() {
        runTealiumAsyncTask(index: 0,
                            request: nil)
    }
    
    func runTealiumAsyncTasks(request: TealiumRequest) {
        runTealiumAsyncTask(index: 0,
                            request: request)
    }
    
    @discardableResult
    internal func runTealiumAsyncTask(index: Int,
                                      request: TealiumRequest?) -> Bool {
        
        if index >= self.count {
            return false
        }
        
        let nextIndex = index + 1
        
        guard let task = self[index] as? TealiumAsyncTask else {
            // Not an async task, skip
            runTealiumAsyncTask(index: nextIndex,
                                request: request )
            return false;
        }
        
        task(request) { (nextRequeset) in
            self.runTealiumAsyncTask(index: nextIndex,
                                     request: nextRequeset)
        }
        
        return true
    }
}
