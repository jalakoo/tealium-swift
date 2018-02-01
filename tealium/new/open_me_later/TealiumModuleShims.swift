//
//  TealiumModuleShims.swift
//  tealium-swift
//
//  Created by Jason Koo on 1/31/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

struct TealiumShim {
    let delegate: TealiumModuleShimDelegate
    let module: TealiumModule
}

class TealiumModuleShims {
    
    static var appDataShim: TealiumShim?
    
    class func appData() -> TealiumAsyncTask {
        
        return { (request:TealiumRequest?, taskCompletion: @escaping TealiumAsyncTaskCompletion) in

            if appDataShim == nil {
                let shim = TealiumModuleShimDelegate()
                let module = TealiumAppDataModule(delegate: shim)
                appDataShim = TealiumShim(delegate: shim,
                                          module: module)
            }
            
            if let enable = request as? TealiumEnableRequest {
                appDataShim?.module.enable(enable)
            }
            
            if let disable = request as? TealiumDisableRequest {
                appDataShim?.module.disable(disable)
            }
            
            if let track = request as? TealiumTrackRequest {
                appDataShim?.module.track(track)
            }
            
            appDataShim?.delegate.onFinished(block: { (module, request) in
                // TODO: Pass the module on?
                taskCompletion(request)
            })
            
            appDataShim?.delegate.onRequest(block: { (module, request) in
                // TOOD: Pass the module on?
                taskCompletion(request)
            })
        }
        
    }
    
    static var autotrackingShim: TealiumShim?
    
    class func autotracking() -> TealiumAsyncTask {
        
        return { (request:TealiumRequest?, taskCompletion: @escaping TealiumAsyncTaskCompletion) in
            
            if autotrackingShim == nil {
                let shim = TealiumModuleShimDelegate()
                let module = TealiumAutotrackingModule(delegate: shim)
                autotrackingShim = TealiumShim(delegate: shim,
                                               module: module)
            }
            
            if let enable = request as? TealiumEnableRequest {
                autotrackingShim?.module.enable(enable)
            }
            
            if let disable = request as? TealiumDisableRequest {
                autotrackingShim?.module.disable(disable)
            }
            
            if let track = request as? TealiumTrackRequest {
                autotrackingShim?.module.track(track)
            }
            
            autotrackingShim?.delegate.onFinished(block: { (module, request) in
                // TODO: Pass the module on?
                taskCompletion(request)
            })
            
            autotrackingShim?.delegate.onRequest(block: { (module, request) in
                // TOOD: Pass the module on?
                taskCompletion(request)
            })
            
        }
    }
    
//    static var shims = [TealiumShim]()
//
//    class func shimFor<T: TealiumModule>(_ module: T.Type) -> TealiumAsyncTask {
//
//        return { (request:TealiumRequest?, taskCompletion: @escaping TealiumAsyncTaskCompletion) in
//
//            let shim = shims.first(where: {$0.module == module})
//            if shim == nil{
//                let shim = TealiumModuleShimDelegate()
//                let module = T(delegate: shim)
//                let newShim = TealiumShim(delegate: shim,
//                                          module: module)
//                shims.append(newShim)
//            }
//
//            if let enable = request as? TealiumEnableRequest {
//                module.enable(enable)
//            }
//
//            if let disable = request as? TealiumDisableRequest {
//                module.disable(disable)
//            }
//
//            if let track = request as? TealiumTrackRequest {
//                module.track(track)
//            }
//
//            shim?.delegate.onFinished(block: { (module, request) in
//                // TODO: Pass the module on?
//                taskCompletion(request)
//            })
//
//            shim?.delegate.onRequest(block: { (module, request) in
//                // TOOD: Pass the module on?
//                taskCompletion(request)
//            })
//
//
//        }
//
//    }
    
}
