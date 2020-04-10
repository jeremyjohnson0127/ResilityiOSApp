//
//  PXIntExtension.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

extension Int {
    
    // MARK:- Internal
    
    func intToBytesArray(_ length: Int) -> [UInt8] {
        
        var intValue = self
        let data = Data(bytes: &intValue, count: length)
        
        return data.array
    }
}
