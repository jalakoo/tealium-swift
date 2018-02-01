//
//  TeailumModuleShimDelegate.swift
//  ios
//
//  Created by Jason Koo on 1/31/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

typealias TealiumModuleShimDelegateCompletion = (_ module: TealiumModule, _ request: TealiumRequest)->()

class TealiumModuleShimDelegate: TealiumModuleDelegate {
    
    var onFinishBlock: TealiumModuleShimDelegateCompletion?
    var onRequestBlock: TealiumModuleShimDelegateCompletion?
    
    func onFinished(block: @escaping TealiumModuleShimDelegateCompletion) {
        self.onFinishBlock = block
    }
    
    func onRequest(block: @escaping TealiumModuleShimDelegateCompletion) {
        self.onRequestBlock = block
    }
    
    func tealiumModuleFinished(module: TealiumModule,
                               process: TealiumRequest){
        self.onFinishBlock?(module, process)
    }
    
    func tealiumModuleRequests(module: TealiumModule,
                               process: TealiumRequest){
        self.onRequestBlock?(module, process)
    }
    
    
}
