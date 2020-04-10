//
//  PXSource.swift
//  PluxAPI
//
//  Created by Carlos Dias on 07/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

open class PXSource: NSObject {
    
    // MARK:- Properties
    
    open var port: Int
    open var numberOfBits: Int
    open var channelMask: UInt8
    open var frequencyDivisor: Int
    
    // MARK:- Lifecycle
    
    public init(port: Int, numberOfBits: Int, channelMask: UInt8, frequencyDivisor: Int) {
        
        self.port = port
        self.numberOfBits = numberOfBits
        self.channelMask = channelMask
        self.frequencyDivisor = frequencyDivisor
    }
}
