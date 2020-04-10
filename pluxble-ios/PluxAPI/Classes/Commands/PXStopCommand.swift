//
//  PXStopCommand.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXStopCommand: PXCommand {

    // MARK:- Lifecycle
    
    override init() {
        
        super.init()
        
        let commandProperties = PXCommandProperties(commandPayload: PXCommandConstants.kCommandStop)
        self.commandData = commandProperties.commandData
        
        PXLogManager.sharedInstance.log("[COMMAND] Stop command: \(self.commandData.byteString)")
    }
}
