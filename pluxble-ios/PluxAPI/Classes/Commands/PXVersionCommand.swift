//
//  PXVersionCommand.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXVersionCommand: PXCommand {

    // MARK:- Lifecycle
    
    override init() {
        
        super.init()
        
        let commandProperties = PXCommandProperties(commandPayload: PXCommandConstants.kCommandVersion)
        self.commandData = commandProperties.commandData
        
        PXLogManager.sharedInstance.log("[COMMAND] Version command: \(self.commandData.byteString)")
    }
}
