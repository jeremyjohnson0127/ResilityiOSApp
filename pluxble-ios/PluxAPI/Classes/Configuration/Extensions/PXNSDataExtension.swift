//
//  PXNSDataExtension.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 09/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

extension Data {
    
    //MARK:- Properties
    
    var byteBuffer: UnsafeMutableBufferPointer<UInt8> {
        
        let myBytes = withUnsafeBytes { (data:UnsafePointer<UInt8>) -> UnsafePointer<UInt8> in
            return data;
        }
        return UnsafeMutableBufferPointer(start: UnsafeMutablePointer(mutating: myBytes), count: self.count)
    }
    
    var array: [UInt8] {
        
        return Array(byteBuffer)
    }
    
    var intArray: [Int] {
        
        return byteBuffer.map(Int.init)
    }
    
    var byteString: String {
        
        return byteBuffer.lazy.map({"\(NSString.init(format: "%02X", $0))"}).joined(separator: " ")
    }
    
    var byteStringArray: [String] {
        
        return byteBuffer.lazy.map({"\(NSString.init(format: "%02X", $0))"})
    }
}

