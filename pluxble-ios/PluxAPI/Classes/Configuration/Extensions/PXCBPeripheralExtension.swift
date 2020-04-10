//
//  PXCBPeripheralExtension.swift
//  PluxAPI
//
//  Created by Carlos Dias on 17/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import CoreBluetooth

extension CBPeripheral {
    
    //MARK:- Internal
    
    func isConnected () -> Bool {
        
        return self.state == CBPeripheralState.connected
    }
}
