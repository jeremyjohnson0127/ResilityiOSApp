//
//  PXCommandArguments.swift
//  PluxAPI
//
//  Created by Carlos Dias on 07/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXCommandArguments: NSObject {
    
    // MARK:- Properties
    
    fileprivate (set) var baseFrequency: Float
    fileprivate (set) var sources: [PXSource]
    fileprivate (set) var startTime: Int64!
    fileprivate (set) var duration: Int64!
    fileprivate (set) var numberOfRepeats: Int!
    fileprivate (set) var repeatPeriod: Int64!
    fileprivate (set) var time: Int64!
    
    // MARK:- Lifecycle
    
    init(baseFrequency: Float, sources: [PXSource], startTime: Int64, duration: Int64, numberOfRepeats: Int, repeatPeriod: Int64, time: Int64) {
        
        self.baseFrequency = baseFrequency
        self.sources = sources
        self.startTime = startTime
        self.duration = duration
        self.numberOfRepeats = numberOfRepeats
        self.repeatPeriod = repeatPeriod
    }
    
    init(baseFrequency: Float, sources: [PXSource]) {
        
        self.baseFrequency = baseFrequency
        self.sources = sources
    }
}
