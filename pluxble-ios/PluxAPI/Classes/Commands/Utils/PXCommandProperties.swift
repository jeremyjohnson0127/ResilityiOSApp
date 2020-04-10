//
//  PXCommandProperties.swift
//  PluxAPI
//
//  Created by Carlos Dias on 07/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXCommandProperties: NSObject {

    // MARK:- Properties
    
    var commandData: Data!
    var commandLenght: Int!
    
    // MARK:- Lifecycle
    
    override init() {
    
        super.init()
    }
    
    init(commandData: Data, commandLenght: Int) {
    
        self.commandData = commandData
        self.commandLenght = commandLenght
    }
    
    init(commandPayload: [UInt8]) {
    
        let length = UInt8(commandPayload.count)
        let crc: UInt8 = getCrc8(commandPayload)
        
        var command = Array <UInt8>(repeating: UInt8(), count: commandPayload.count + 3)
        
        command[0] = 0xAA
        command[1] = length
        
        for i in 0 ... commandPayload.count-1 {
            
            command[i + 2] = commandPayload[i]
        }
        
        command[command.count - 1] = crc
        
        self.commandData = Data(bytes: UnsafePointer<UInt8>(command), count: command.count)
    }
}
