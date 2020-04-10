//
//  PXDeviceService.swift
//  PluxAPI
//
//  Created by Carlos Dias on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import Foundation

class PXDeviceService: NSObject {

    // MARK:- Properties
    
    fileprivate (set) var baseFrequency: Float
    fileprivate (set) var frequencyDivisor: Int
    
    // MARK:- Lifecycle
    
    init(baseFrequency: Float, frequencyDivisor: Int) {
        
        self.baseFrequency = baseFrequency
        self.frequencyDivisor = frequencyDivisor
    }
}
