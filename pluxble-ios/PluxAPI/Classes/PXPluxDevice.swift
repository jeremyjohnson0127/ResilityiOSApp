//
//  PXPluxDevice.swift
//  PluxAPI
//
//  Created by Carlos Dias on 15/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

open class PXPluxDevice: NSObject {

    // MARK:- Properties
    
    let productName: String
    let productIdentifier: Int
    let firmwareVersion: Int
    let hardwareVersion: Int
    
    
    // MARK:- Lifecycle
    
    init(productName: String, productIdentifier: Int, firmwareVersion: Int, hardwareVersion: Int) {
        
        self.productName = productName
        self.productIdentifier = productIdentifier
        self.firmwareVersion = firmwareVersion
        self.hardwareVersion = hardwareVersion
        
        super.init()
    }
    
    override open var description: String {
    
        return "DEV: \(self.productName); PID: \(self.productIdentifier); FW version: \(self.firmwareVersion); HW version: \(self.hardwareVersion);"
    }
}
