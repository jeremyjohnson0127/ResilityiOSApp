//
//  PXFloatExtension.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

extension Float {
    
    // MARK:- Internal
    
    func floatToBytesArray(_ length: Int) -> [UInt8] {
        
        var floatValue = self
        let data = Data.init(bytes: &floatValue, count: length)
        
        return data.array
    }
}
