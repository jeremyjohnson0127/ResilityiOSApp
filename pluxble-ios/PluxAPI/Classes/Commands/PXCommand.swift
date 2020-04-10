//
//  PXCommand.swift
//  PluxAPI
//
//  Created by Carlos Dias on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXCommand: NSObject {
    
    // MARK:- Public
    
    var commandData: Data!
    var numberOfChannels: Int!
    var baseFrequency: Float!
    var sourcesArray: [PXSource]!
    
    
    // MARK:- Lifecycle
    
    override init() {
        
        super.init()
    }
    
    init(commandData: Data) {
        
        self.commandData = commandData
    }
}
