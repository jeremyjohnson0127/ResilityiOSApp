//
//  PXCBCharacteristicExtension.swift
//  PluxAPI
//
//  Created by Carlos Dias on 13/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import CoreBluetooth

extension CBCharacteristic {
    
    //MARK:- Internal
    
    func getDescriptorFromUUIDString(_ UUIDString: String) -> CBDescriptor? {
        
        if let descriptors = self.descriptors {
        
            for descriptor in descriptors {
                
                if descriptor.uuid.uuidString == UUIDString {
                    
                    return descriptor
                }
            }
        }
        
        return nil
    }
    
    func parseCharacteristicCommandsReceivedData(device: PXDevice) -> (result: Bool, response: AnyObject) {
        
        if let data = self.value {
            
            if data.count > 0 {
                
                let dataBytesArray = data.array
                
                if ((dataBytesArray[0] >> 7) & 0x01) == 1 {
                
                    // Frame
                    
                    let pluxFrame = PXPluxFrame.parsePluxFrameFromDevice(device, bytesArray: dataBytesArray)
                    
                    PXLogManager.sharedInstance.log("[PARSE] Frame: \(pluxFrame)")
                    return (true, pluxFrame)
                    
                } else if dataBytesArray[0] >= 2 {
                    
                    let sData = data.byteStringArray
                    
                    if sData[0] == "08" {
                        
                        // Disconnect Event
                        
                        //TODO:
                        PXLogManager.sharedInstance.log("[PARSE] Disconnect event")
                        return (true, "Disconnect event" as AnyObject)
                    
                    } else if sData[0] == "09" {
                    
                        // Noise Event
                        
                        //TODO:
                        PXLogManager.sharedInstance.log("[PARSE] Noise event")
                        return (true, "Noise event" as AnyObject)
                        
                    } else if sData[0] == "0A" {
                        
                        // Battery Event
                        
                        //TODO:
                        PXLogManager.sharedInstance.log("[PARSE] Battery event")
                        return (true, "Battery event" as AnyObject)
                    }
                    
                } else if data.count > 3 {
                    
                    var sData = dataBytesArray
                    sData.remove(at: 0)
                    
                    if sData.count == 6 {
                        
                        // Version
                        
                        let pluxDevice = PXPluxDevice.parsePluxDeviceFromBytesArray(sData)
                        
                        PXLogManager.sharedInstance.log("[PARSE] version: \(pluxDevice)")
                        return (true, pluxDevice)
                        
                    } else {
                        
                        // Description
                        
                        if let description = String(data: Data(bytes: UnsafePointer<UInt8>(sData), count: sData.count), encoding: String.Encoding.utf8) {
                        
                            PXLogManager.sharedInstance.log("[PARSE] description: \(description)")
                            return (true, description as AnyObject)
                        
                        } else {
                        
                            return (false, "Error parsing description" as AnyObject)
                        }
                    }
                    
                } else {
                    
                    let sData = data.byteStringArray
                    
                    if sData[0] == "01" {
                    
                        // Command Error
                        
                        let commandError = PXCommandError(rawValue:dataBytesArray[1])
                        
                        PXLogManager.sharedInstance.log("[PARSE] Command Error: \(commandError)")
                        return (false, "Command error" as AnyObject)
                        
                    } else if sData[0] == "00" {
                    
                        // Command Reply
                        
                        PXLogManager.sharedInstance.log("[PARSE] Command Replay: \(data.byteString)")
                        
                        if sData.count == 3 {
                           
                            // Battery Level
                            
                            let batteryLevel = mergeBytes(dataBytesArray[1], b2: dataBytesArray[2])
                            
                            PXLogManager.sharedInstance.log("[PARSE] Battery level: \(batteryLevel)")
                            return (true, batteryLevel as AnyObject)
                        
                        } else {
                        
                            return (true, "Command Replay" as AnyObject)
                        }
                    }
                }
            }
        }
        
        return (false, "Unknown error" as AnyObject)
    }
}
