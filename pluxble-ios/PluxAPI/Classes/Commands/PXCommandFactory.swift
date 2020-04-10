//
//  PXCommandFactory.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 08/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXCommandFactory: NSObject {

    // MARK:- Public
    
    static func getCommandForIdentifier(_ commandIdentifier: PXCommandIdentifier, baseFrequency: Float? = nil, sourcesArray: [PXSource]? = nil) -> PXCommand? {
        
        switch commandIdentifier {
            
        case .start:
            
            if let baseFrequency = baseFrequency {
                
                if let sourcesArray = sourcesArray {
                
                    return PXStartCommand(baseFrequency: baseFrequency, sourcesArray: sourcesArray)
                }
            }
            
            PXLogManager.sharedInstance.log("The command START must have a base frequancy and a sources array defined!")
            
            return nil
            
        case .stop:
            return PXStopCommand()
            
        case .description:
            return PXDescriptionCommand()
            
        case .reset:
            return PXResetCommand()
            
        case .version:
            return PXVersionCommand()
        }
    }
}
