//
//  PXPluxDeviceExtension.swift
//  PluxAPI
//
//  Created by Carlos Dias on 15/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

extension PXPluxDevice {
    
    //MARK:- Internal
    
    static func parsePluxDeviceFromBytesArray(_ bytesArray: [UInt8]) -> PXPluxDevice {
        
        let majorPID = bytesArray[0]
        let minorPID = bytesArray[1]
        
        let productName = "\(PXDevicesPIDStruct.getPXDevicePIDFromPID(Int(majorPID), minor: Int(minorPID)))"
        let productIdentifier = getProductIdentifier(majorPID, b2: minorPID)
        let firmwareVersion = frameDecodeMergeBytes(bytesArray[2], b2: bytesArray[3])
        let hardwareVersion = frameDecodeMergeBytes(bytesArray[4], b2: bytesArray[5])
        
        let pluxDevice = PXPluxDevice(productName: productName.uppercased(), productIdentifier: productIdentifier, firmwareVersion: firmwareVersion, hardwareVersion: hardwareVersion)
        
        return pluxDevice
    }
}
