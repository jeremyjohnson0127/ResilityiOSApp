//
//  PXBiopluxCommunication.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 02/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol PXBiopluxCommunicationDelegate {

    
    func didDiscoverNewDevice()
}

class PXBiopluxCommunication: NSObject, CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager!
    var delegate: PXBiopluxCommunicationDelegate?
    
    init(delegate: PXBiopluxCommunicationDelegate) {
    
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
        self.delegate = delegate
    }

    // MARK: Public
    
    func scanDevices() {
    
        print("scanDevices")

        let deviceID: CBUUID = CBUUID(string: PXConstants.kDataServiceUUID)
        
        if(centralManager.state == .PoweredOn) {
        
            self.centralManager.scanForPeripheralsWithServices([deviceID], options: nil)
        
        } else {
        
            print("Device Not Connected");
        }
    }
    
    // MARK: Private
    
    func bluetoothPoweredOff() {
    
        if let delegate: PXBiopluxCommunicationDelegate = self.delegate {
            
            delegate.didDiscoverNewDevice()
        }
        
    }
    
    
    // MARK: CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        print("centralManagerDidUpdateState");
        
        switch central.state {
            
            case .PoweredOff:
                
                
                
                print("PoweredOff")
        
            case .PoweredOn:
                print("PoweredOn")

            case .Resetting:
                print("Resetting")

            case .Unauthorized:
                print("Unauthorized")

            case .Unknown:
                print("Unknown")

            case .Unsupported:
                print("Unauthorized")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print("didDiscoverPeripheral")
        
        if let delegate: PXBiopluxCommunicationDelegate = self.delegate {
        
            delegate.didDiscoverNewDevice()
        }
    }
}
