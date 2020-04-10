//
//  PXEnvironmentConstants.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 03/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

struct PXEnvironmentConstants {

    static let kEnvironmentUUIDService              = "C566488A-0882-4E1B-A6D0-0B717E652234"
    static let kEnvironmentUUIDCommands             = "4051EB11-BF0A-4C74-8730-A48F4193FCEA"
    static let kEnvironmentUUIDFrames               = "40FDBA6B-672E-47C4-808A-E529ADFF3633"
    static let kEnvironmentUUIDClientCharacteristic = "00002902-0000-1000-8000-00805F9B34FB"
}

struct PXDevicesPIDStruct {
    
    static let deviceUnknown     = (majorPID: -1, minorPID: -1)
    static let bioPlux1          = (majorPID: 1, minorPID: 1)
    static let bioSignalsPlux8ch = (majorPID: 2, minorPID: 1)
    static let biosignalsPlux4ch = (majorPID: 2, minorPID: 2)
    static let motionPlux        = (majorPID: 2, minorPID: 10)
    static let ee                = (majorPID: 3, minorPID: 1)
    static let usbDataCable      = (majorPID: 4, minorPID: 1)
    static let gestureWatch      = (majorPID: 5, minorPID: 1)
    static let muscleBan         = (majorPID: 5, minorPID: 2)
    static let bitalino1         = (majorPID: 6, minorPID: 1)
    static let bitalino2         = (majorPID: 6, minorPID: 2)
    
    static let devicesPIDArray = [deviceUnknown, bioPlux1, bioSignalsPlux8ch, biosignalsPlux4ch, motionPlux, ee, usbDataCable, gestureWatch, muscleBan, bitalino1, bitalino2]
    
    let majorPID: Int
    let minorPID: Int
    
    static func getPXDevicePIDFromPID(_ major: Int, minor: Int) -> PXDevicesPID {
    
        for i in 0 ..< devicesPIDArray.count {
            
            let devicePID = devicesPIDArray[i]
            
            if devicePID.majorPID == major && devicePID.minorPID == minor {
               
                if let pid = PXDevicesPID(rawValue: i) {
                
                    return pid
                }
            }
        }
        
        return .deviceUnknown
    }
}
