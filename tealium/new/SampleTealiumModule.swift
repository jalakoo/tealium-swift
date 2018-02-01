//
//  AnAwesomeNewTealiumModule.swift
//  ios
//
//  Created by Jason Koo on 1/31/18.
//  Copyright © 2018 tealium. All rights reserved.
//

import Foundation

class SampleTealiumModule: NewTealiumModule {
    
    override func enable(_ request: TealiumEnableRequest) {
        print("*** \(#function):\(#line): Enable called with request:\(request)")
        finishedEnabling(true, nil, nil)
    }
    
    override func disable(_ request: TealiumDisableRequest) {
        print("*** \(#function):\(#line): Disable called with request:\(request)")
        finishedDisabling(true, nil, nil)
    }
    
    override func track(_ request: TealiumTrackRequest) {
        print("*** \(#function):\(#line): Track called with request:\(request)")
        finishedTracking(true, nil, nil)
    }
    
}
