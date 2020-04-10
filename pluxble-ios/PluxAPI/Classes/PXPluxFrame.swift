//
//  PXPluxFrame.swift
//  PluxAPI
//
//  Created by Carlos Dias on 16/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

open class PXPluxFrame: NSObject {

    // MARK:- Properties
    
    open let identifier: String
    open let sequence: Int
    open let analogData: [Int]
    open let digitalInput: Int
    open let comments: String
    
    // MARK:- Lifecycle
    
    init(identifier: String, sequence: Int, analogData: [Int], digitalInput: Int, comments: String) {
        
        self.identifier = identifier
        self.sequence = sequence
        self.analogData = analogData
        self.digitalInput = digitalInput
        self.comments = comments
        
        super.init()
    }
    
    override open var description: String {
        
        return "Device Id: \(self.identifier); Sequence: \(self.sequence); AnalogData: \(self.analogData); DigitalInput: \(self.digitalInput); Comments: \(self.comments);"
    }
}
