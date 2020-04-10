//
//  PXStartCommand.swift
//  PluxAPI
//
//  Created by Carlos Dias on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXStartCommand: PXCommand {
    
    // MARK:- Lifecycle
    
    init(baseFrequency: Float, sourcesArray: [PXSource]) {
        
        super.init()
        
        self.baseFrequency = baseFrequency
        self.sourcesArray = sourcesArray
        
        self.commandData = self.commandStart()
    }
    
    // MARK:- Private
    
    fileprivate func commandStart() -> Data {
        
        let deviceService = PXDeviceService(baseFrequency: self.baseFrequency, frequencyDivisor: self.sourcesArray[0].frequencyDivisor)
        
        let commandArguments = PXCommandArguments(baseFrequency: deviceService.baseFrequency, sources: self.sourcesArray)
        
        let commandProperties = self.commandPropertiesFromArguments(commandArguments)
        
        PXLogManager.sharedInstance.log("[COMMAND] Start command: \(commandProperties.commandData.byteString)")
        
        if let command = commandProperties.commandData {
            
            return command as Data
        }
        
        return Data()
    }
    
    fileprivate func commandPropertiesFromArguments(_ commandArguments: PXCommandArguments) -> PXCommandProperties {
        
        var baseFrequencyArray: [UInt8] = Array(commandArguments.baseFrequency.floatToBytesArray(4)).reversed()
        
        let sources = commandArguments.sources
        
        let cmd: [UInt8] = [0x07, 0x01,
                            0x00, 0x00, 0x00, 0x00,
                            0xFF, 0xFF, 0xFF, 0xFF,
                            0x00, 0x00,
                            0x00, 0x00, 0x00, 0x00,
                            baseFrequencyArray[3], baseFrequencyArray[2], baseFrequencyArray[1], baseFrequencyArray[0],
                            UInt8(sources.count)]
        
        var command = Array <UInt8>(repeating: UInt8(), count: cmd.count + 8 * sources.count + 1)
        command[0 ... cmd.count - 1] = cmd[0 ... cmd.count - 1]
        
        var position: Int = 21
        
        for source in sources {
            
            var freqDivisor: [UInt8] = source.frequencyDivisor.intToBytesArray(4).reversed()
            
            var sourceByteArray = Array <UInt8>(repeating: UInt8(), count: 8)
            sourceByteArray[0] = UInt8((((getResolutionBit(source.numberOfBits)) << 7) & 0x80) | source.port & 0x7F)
            sourceByteArray[1] = freqDivisor[3]
            sourceByteArray[2] = freqDivisor[2]
            sourceByteArray[3] = source.channelMask
            sourceByteArray[4] = 0x00
            sourceByteArray[5] = 0x00
            sourceByteArray[6] = 0x00
            sourceByteArray[7] = 0x00
            
            command[position ... position + sourceByteArray.count - 1] = sourceByteArray[0 ... sourceByteArray.count - 1]
            position += sourceByteArray.count
        }
        
        command[command.count - 1] = 0x00
        
        return PXCommandProperties(commandPayload: command)
    }
}
