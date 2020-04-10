//
//  PXDevice.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 03/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import CoreBluetooth

public typealias pluxFrameCompletionBlock = ((_ result: Bool, _ pluxFrame: PXPluxFrame?) -> Void)
public typealias pluxDeviceCompletionBlock = ((_ result: Bool, _ pluxDevice: PXPluxDevice?) -> Void)
public typealias stringCompletionBlock = ((_ result: Bool, _ description: String?) -> Void)
public typealias resultCompletionBlock = ((_ result: Bool) -> Void)

open class PXDevice: NSObject, CBPeripheralDelegate {
    
    // MARK:- Properties
    
    open var deviceName: String
    open let deviceUUID: String
    
    let peripheral: CBPeripheral
    
    open var delegate: PXBioPluxManagerDelegate?
    
    var starCommandCompletionBlock: pluxFrameCompletionBlock?
    var stopCommandCompletionBlock: resultCompletionBlock?
    var versionCommandCompletionBlock: pluxDeviceCompletionBlock?
    var descriptionCommandCompletionBlock: stringCompletionBlock?
    
    var characteristicCommands: CBCharacteristic!
    var characteristicFrames: CBCharacteristic!
    
    var descriptorCommands: CBDescriptor!
    var descriptorFrames: CBDescriptor!
    
    var nChannels: Int
    
    // MARK:- Lifecycle
    
    public init(deviceName: String, deviceUUID: String, peripheral: CBPeripheral) {
    
        self.deviceName = deviceName
        self.deviceUUID = deviceUUID
        self.peripheral = peripheral
        self.nChannels = 8
        
        super.init()
        
        self.peripheral.delegate = self
    }
    
    // MARK:- Public
    
    open func startAcquisitionWithBaseFrequency(_ baseFrequency: Float, sourcesArray: [PXSource], completionBlock: pluxFrameCompletionBlock?) {

        if self.peripheral.isConnected() {
            
            if let command: PXCommand = PXCommandFactory.getCommandForIdentifier(.start, baseFrequency: baseFrequency, sourcesArray: sourcesArray) {
                
                self.changeNumberOfChannels(sourcesArray)
                if(self.characteristicCommands != nil){
                    self.writeCharacteristic(self.characteristicCommands, commandData: command.commandData as Data)
                }
                    self.starCommandCompletionBlock = completionBlock

            }
        
        } else {
        
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
            
            if let completionBlock = completionBlock {
                
                completionBlock(false, nil)
            }
        }
    }
    
    open func stopAcquisitionWithCompletionBlock(_ completionBlock: resultCompletionBlock?) {
    
        if self.peripheral.isConnected() {
            
            if let command: PXCommand = PXCommandFactory.getCommandForIdentifier(.stop) {
                
                self.writeCharacteristic(self.characteristicCommands, commandData: command.commandData as Data)
                self.stopCommandCompletionBlock = completionBlock
            }
            
        } else {
            
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
            
            if let completionBlock = completionBlock {
            
                completionBlock(false)
            }
        }
    }
    
    open func getVersionOfDeviceWithCompletionBlock(_ completionBlock: pluxDeviceCompletionBlock?) {
    
        if self.peripheral.isConnected() {
            
            if let command: PXCommand = PXCommandFactory.getCommandForIdentifier(.version) {
                
                self.writeCharacteristic(self.characteristicCommands, commandData: command.commandData as Data)
                self.versionCommandCompletionBlock = completionBlock
            }
            
        } else {
            
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
            
            if let completionBlock = completionBlock {
                
                completionBlock(false, nil)
            }
        }
    }
    
    open func getDescriptionOfDeviceWithCompletionBlock(_ completionBlock: stringCompletionBlock?) {
    
        if self.peripheral.isConnected() {
            
            if let command: PXCommand = PXCommandFactory.getCommandForIdentifier(.description) {
                
                self.writeCharacteristic(self.characteristicCommands, commandData: command.commandData as Data)
                self.descriptionCommandCompletionBlock = completionBlock
            }
            
        } else {
            
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
            
            if let completionBlock = completionBlock {
                
                completionBlock(false, nil)
            }
        }
    }
    
    open func resetDevice() {
        
        if self.peripheral.isConnected() {
            
            if let command: PXCommand = PXCommandFactory.getCommandForIdentifier(.reset) {
                
                self.writeCharacteristic(self.characteristicCommands, commandData: command.commandData as Data)
            }
            
        } else {
            
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
        }
    }
    
    // MARK:- Private
    
    fileprivate func writeCharacteristic(_ characteristic: CBCharacteristic, commandData: Data) {
        
        self.peripheral.writeValue(commandData, for: characteristic, type: .withResponse)
    }
    
    fileprivate func enableNotificationsForCharacteristic(_ characteristic: CBCharacteristic, enable: Bool) {
    
        self.peripheral.setNotifyValue(enable, for: characteristic)
    }
    
    fileprivate func parseReceivedDataFromCharacteristic(_ characteristic: CBCharacteristic) {
    
        if characteristic.uuid == self.characteristicCommands.uuid {
            
            let parse = characteristic.parseCharacteristicCommandsReceivedData(device: self)
            
            switch parse.response {
                
            case let pluxFrame as PXPluxFrame:
                
                if let completionBlock = self.starCommandCompletionBlock {
                    
                    completionBlock(parse.result, pluxFrame)
                }
                
            case let pluxDevice as PXPluxDevice:
                
                if let completionBlock = self.versionCommandCompletionBlock {
                    
                    completionBlock(parse.result, pluxDevice)
                    self.versionCommandCompletionBlock = nil
                }
                
            case let description as String:
                
                if let completionBlock = self.descriptionCommandCompletionBlock {
                    
                    completionBlock(parse.result, description)
                    self.descriptionCommandCompletionBlock = nil
                    
                } else if let completionBlock = self.stopCommandCompletionBlock {
                    
                    completionBlock(parse.result)
                    self.stopCommandCompletionBlock = nil
                }
                
            default:
                break
            }
        }
    }

    fileprivate func changeNumberOfChannels(_ sources: [PXSource]) {
        
        var numberOfChannels: Int = 0
        
        for source: PXSource in sources {
            
            var channelMask = source.channelMask
            
            for _ in 0...8 {
                
                if (channelMask & 0x01) == 1 {
                    
                    numberOfChannels = numberOfChannels + 1
                }
                
                channelMask = channelMask >> 0x01
            }
        }
        
        self.nChannels = numberOfChannels
    }
    
    // MARK:- CBPeripheralDelegate
    
    // MARK: > Services
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if let actualError = error {
        
            PXLogManager.sharedInstance.log("[ERROR] didDiscoverServices with error: \(actualError)")
        
        } else {
            
            if let services = peripheral.services {
            
                PXLogManager.sharedInstance.log("[DISCOVER] didDiscoverServices:")
                
                for service: CBService in services {
                    
                    PXLogManager.sharedInstance.log("   - service: \(service)")
                    
                    if service.uuid.uuidString == PXEnvironmentConstants.kEnvironmentUUIDService {
                        
                        peripheral.discoverCharacteristics(nil, for: services[0])
                    }
                }
            }
        }
    }
    
    // MARK: > Characteristics
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if let actualError = error {
        
            PXLogManager.sharedInstance.log("[ERROR] didDiscoverCharacteristicsForService with error: \(actualError)")
            
        } else {
        
            PXLogManager.sharedInstance.log("[DISCOVER] didDiscoverCharacteristicsForService: \(service)")
            
            for characteristic: CBCharacteristic in service.characteristics! {
                
                PXLogManager.sharedInstance.log("   - characteristic: \(characteristic)")
                
                if characteristic.uuid.uuidString == PXEnvironmentConstants.kEnvironmentUUIDCommands {
                
                    self.characteristicCommands = characteristic
                    self.enableNotificationsForCharacteristic(characteristic, enable: true)
//                    self.peripheral.discoverDescriptorsForCharacteristic(self.characteristicCommands)
//
//                } else if characteristic.UUID.UUIDString == PXEnvironmentConstants.kEnvironmentUUIDFrames {
//                
//                    self.characteristicFrames = characteristic
//                    self.peripheral.discoverDescriptorsForCharacteristic(self.characteristicFrames)
                }
            }
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didWriteValueForCharacteristic with error \(actualError)")
            
        } else {
            
            PXLogManager.sharedInstance.log("[WRITE] didWriteValueForCharacteristic: \(characteristic)")
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didUpdateValueForCharacteristic with error: \(actualError)")

        } else {
            
//            PXLogManager.sharedInstance.log("[UPDATE] didUpdateValueForCharacteristic: \(characteristic)")
            self.parseReceivedDataFromCharacteristic(characteristic)
        }
    }
    
    // MARK: > Descriptors
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didDiscoverDescriptorsForCharacteristic with error: \(actualError)")
            
        } else {
            
            PXLogManager.sharedInstance.log("[DISCOVER] didDiscoverDescriptorsForCharacteristic: \(characteristic)")
            
            for descriptor: CBDescriptor in characteristic.descriptors! {
                
                PXLogManager.sharedInstance.log("descriptor: \(descriptor)")
            }
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didUpdateNotificationStateFor with error: \(actualError)")
            
        } else {
            PXLogManager.sharedInstance.log("[DISCOVER] didUpdateNotificationStateFor: \(characteristic)")
            self.delegate?.deviceReady?()
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didWriteValueForDescriptor with error: \(actualError)")
            
        } else {
            
            PXLogManager.sharedInstance.log("[WRITE] didWriteValueForDescriptor: \(descriptor)")
        }
    }
    
    open func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
        if let actualError = error {
            
            PXLogManager.sharedInstance.log("[ERROR] didUpdateValueForDescriptor with error: \(actualError)")
            
        } else {
            
            PXLogManager.sharedInstance.log("[UPDATE] didUpdateValueForDescriptor: \(descriptor)")
        }
    }
}
