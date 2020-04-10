//
//  PXLogManager.swift
//  PluxAPI
//
//  Created by Carlos Dias on 07/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

class PXLogManager: NSObject {

    // MARK:- Properties
    
    var logLevel: PXLogLevel
    static let sharedInstance = PXLogManager()
    
    // MARK:- Lifecycle
    
    override init() {
        
        logLevel = .none
        super.init()
    }
    
    // MARK:- Public
    
    func log(_ message: String) {
    
        switch self.logLevel {
            
        case .simple:
            let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
            print("[PluxAPI \(timestamp)]: \(message)")
            break
        
        case .none: break
        }
    }
}
