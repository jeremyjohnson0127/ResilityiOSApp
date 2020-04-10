//
//  PXResetCommand.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXResetCommand: PXCommand {

    // MARK:- Lifecycle
    
    override init() {
        
        super.init()
        
        let commandProperties = PXCommandProperties(commandPayload: PXCommandConstants.kCommandReset)
        self.commandData = commandProperties.commandData
        
        PXLogManager.sharedInstance.log("[COMMAND] Reset command: \(self.commandData.byteString)")
    }
}
