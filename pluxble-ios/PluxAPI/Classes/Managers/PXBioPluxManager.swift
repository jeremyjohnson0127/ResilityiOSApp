//
//  PXBioPluxManager.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 02/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

@objc
public protocol PXBioPluxManagerDelegate: NSObjectProtocol {
    
    @objc optional func didDiscoverNewDevice(_ device: PXDevice)

    @objc optional func didConnectDevice()
    @objc optional func deviceReady()
    @objc optional func didFailToConnectDevice()
    @objc optional func didDisconnectDevice()
    
    @objc optional func didBluetoothPoweredOff()
    @objc optional func didBluetoothPoweredOn()
}

public extension PXBioPluxManagerDelegate {
    
    func didDiscoverNewDevice(_ device: PXDevice) {}
    
    func didConnectDevice() {}
    func deviceReady() {}
    func didFailToConnectDevice() {}
    func didDisconnectDevice() {}
    
    func didBluetoothPoweredOff() {}
    func didBluetoothPoweredOn() {}
}

open class PXBioPluxManager: NSObject, CBCentralManagerDelegate {
    
    // MARK:- Properties
    
    open var delegate: PXBioPluxManagerDelegate?
    open var logLevel: PXLogLevel {
        
        didSet {
        
            PXLogManager.sharedInstance.logLevel = logLevel
        }
    }
    
    fileprivate var peripheralsArray = [CBPeripheral]()
    fileprivate var centralManager: CBCentralManager
    
    var device: PXDevice!
    
    // MARK:- Lifecycle
    
    public override init() {
        
        self.logLevel = .none
        self.centralManager = CBCentralManager()
        
        super.init()
        
        self.centralManager.delegate = self
    }
    
    // MARK:- Public
    
    open func scanDevices() {
        
        let deviceID: CBUUID = CBUUID(string: PXEnvironmentConstants.kEnvironmentUUIDService)
        
        if centralManager.state == .poweredOn {
            
            self.centralManager.scanForPeripherals(withServices: [deviceID], options: nil)
            PXLogManager.sharedInstance.log("Start scan devices")
            
        } else {
            
            PXLogManager.sharedInstance.log("Bluetooth is currently powered off")
        }
    }
    
    open func stopScanDevices() {
        self.centralManager.stopScan()
        self.peripheralsArray = []
        
        PXLogManager.sharedInstance.log("Stop scan devices")
    }
    
    open func connectDevice(_ device: PXDevice) {
        PXLogManager.sharedInstance.log("Connect Device")
        
        self.device = device
        self.device.delegate = self.delegate

        self.centralManager.connect(device.peripheral, options: nil)
    }
    
    open func disconnectDevice(_ device: PXDevice) {
        
        if device.peripheral.isConnected() {
        
            PXLogManager.sharedInstance.log("Disconnect Device")
            self.centralManager.cancelPeripheralConnection(device.peripheral)
        
        } else {
            
            PXLogManager.sharedInstance.log("[ERROR] peripheral not connect!")
        }
    }
    
    // MARK:- Private
    
    fileprivate func bluetoothPoweredOff() {
    
        PXLogManager.sharedInstance.log("PoweredOff")

        self.delegate?.didBluetoothPoweredOff?()
    }
    
    fileprivate func bluetoothPoweredOn() {
    
        PXLogManager.sharedInstance.log("PoweredOn")
        
        self.delegate?.didBluetoothPoweredOn?()
    }
    
    // MARK:- CBCentralManagerDelegate
    
    open func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        PXLogManager.sharedInstance.log("[UPDATE] centralManagerDidUpdateState:")
        
        switch central.state {
            
            case .poweredOff:
                self.bluetoothPoweredOff()
            
            case .poweredOn:
                self.bluetoothPoweredOn()
            
            case .resetting:
                PXLogManager.sharedInstance.log("   - Resetting")
            
            case .unauthorized:
                PXLogManager.sharedInstance.log("   - Unauthorized")
            
            case .unknown:
                PXLogManager.sharedInstance.log("   - Unknown")
            
            case .unsupported:
                PXLogManager.sharedInstance.log("   - Unauthorized")
        }
    }
    
    open func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
    
        if !self.peripheralsArray.contains(peripheral) {
            
            PXLogManager.sharedInstance.log("[DISCOVER] Did discover new peripheral: \(peripheral)")
            self.peripheralsArray.append(peripheral)
            
            let device: PXDevice = PXDevice(deviceName: peripheral.name==nil ? "No Name" :peripheral.name!, deviceUUID: peripheral.identifier.uuidString, peripheral: peripheral)
            self.delegate?.didDiscoverNewDevice?(device)
        }
    }
    
    open func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        PXLogManager.sharedInstance.log("Connection successfull to peripheral: \(peripheral)")
        
        self.delegate?.didConnectDevice?()
        
        peripheral.delegate = device
        
        let deviceID: CBUUID = CBUUID(string: PXEnvironmentConstants.kEnvironmentUUIDService)
        peripheral.discoverServices([deviceID])
    }
    
    open func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        if let actualError = error {
        
            PXLogManager.sharedInstance.log("[ERROR] Disconnected to peripheral: \(peripheral) with error: \(actualError)")
        
        } else {
        
            PXLogManager.sharedInstance.log("Disconnected to peripheral: \(peripheral) with sucess")

            self.delegate?.didDisconnectDevice?()
        }
    }
    
    open func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
        PXLogManager.sharedInstance.log("[ERROR] Connection failed to peripheral: \(peripheral) with error: \(error)")
        
        self.delegate?.didFailToConnectDevice?()
    }
}
