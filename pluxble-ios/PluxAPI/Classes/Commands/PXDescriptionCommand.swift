//
//  PXDescriptionCommand.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXDescriptionCommand: PXCommand {

    // MARK:- Lifecycle
    
    override init() {
        
        super.init()
        
        let commandProperties = PXCommandProperties(commandPayload: PXCommandConstants.kCommandDescription)
        self.commandData = commandProperties.commandData
        
        PXLogManager.sharedInstance.log("[COMMAND] Description command: \(self.commandData.byteString)")
    }
}
