//
//  PXCommandUtils.swift
//  PluxAPI
//
//  Created by Carlos Dias on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

// MARK:- Public

func getCrc8(_ data: [UInt8]) -> UInt8 {
    
    var crc: UInt8 = 0xFF
    
    for i in 0 ... data.count-1 {
        
        crc = PXCommandConstants.kCommandCRC8Tab[Int((crc ^ data[i]) & 0xFF)]
    }
    
    return crc
}

func getResolutionBit(_ resolution: Int) -> Int {
    
    return resolution == 16 ? 1 : 0
}

func getProductIdentifier(_ b1: UInt8, b2: UInt8) -> Int {

    let bytesArray = [b1,b2]
    let data = Data(bytes: UnsafePointer<UInt8>(bytesArray), count:bytesArray.count)

    var shortInt : UInt16 = 0
    (data as NSData).getBytes(&shortInt, length: MemoryLayout.size(ofValue: shortInt))
 
    return Int(UInt16(bigEndian: shortInt))
}

func mergeBytes(_ b1: UInt8, b2: UInt8) -> Int {
    
    return ((Int(b2) & 0x0F) << 8) | (Int(b1) & 0xFF)
}

func frameDecodeMergeSeqBytes(_ b1: UInt8, b2: UInt8) -> Int {
    
    let bytesArray = [(b1 & ~(1 << 7)), b2]
    
    let data = Data(bytes: UnsafePointer<UInt8>(bytesArray), count:bytesArray.count)
    
    var shortInt : UInt16 = 0
    (data as NSData).getBytes(&shortInt, length: MemoryLayout.size(ofValue: shortInt))
    
    return Int(UInt16(bigEndian: shortInt))
}

func frameDecodeMergeBytes(_ b1: UInt8, b2: UInt8) -> Int {
    
    return (Int(b1) & 0xFF | (Int(b2) << 8) & 0xFFFF)
}

