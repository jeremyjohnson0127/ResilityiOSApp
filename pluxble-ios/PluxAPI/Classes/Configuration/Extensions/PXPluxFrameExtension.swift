//
//  PXPluxFrameExtension.swift
//  PluxAPI
//
//  Created by Carlos Dias on 16/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

extension PXPluxFrame {

    //MARK:- Internal
    
    static func parsePluxFrameFromDevice(_ device: PXDevice, bytesArray: [UInt8]) -> PXPluxFrame {
        
        let sequence = frameDecodeMergeSeqBytes(bytesArray[0], b2: bytesArray[1])
        let bytesBeforeChannels = 2
        let channelsBytesPosition = bytesArray.count
        
        var analogData: [Int] = []
        
        for i in stride(from: bytesBeforeChannels, to: channelsBytesPosition, by: 2){
            
            analogData.append(frameDecodeMergeBytes(bytesArray[i], b2:bytesArray[i+1]))
        }
        
        let pluxFrame = PXPluxFrame(identifier: device.deviceUUID, sequence: sequence, analogData: analogData, digitalInput: 0, comments: "")
        
        return pluxFrame
    }
}
