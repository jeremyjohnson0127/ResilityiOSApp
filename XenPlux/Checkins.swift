//
//  Checkins.swift
//  XenPlux
//
//  Created by diana on 8/20/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class Checkins:NSObject{

    var id: String = ""
    
    var tense : Int = 0
    var relaxed : Int = 0
    var tired : Int = 0
    var rested : Int = 0
    var distracted : Int = 0
    var focused : Int = 0
    var overwhelmed : Int = 0
    var topofthings : Int = 0
    var unhappy : Int = 0
    var content : Int = 0
    var note = ""

    var createdDate = Date()
    var isAllView : Bool = false

    override init(){
        super.init()
    }

    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }

    func dataForUploading() -> [String: Any] {
        return ["tense":tense, "tired":tired, "distracted":distracted, "overwhelmed":overwhelmed, "unhappy":unhappy,"note":note]
    }
    
    func loadFromJSON(json: NSDictionary){
        id = String(json.object(forKey: "id") as! Int)
        
        if let tenseNumber = json.object(forKey: "tense") as? NSNumber {
            tense = tenseNumber.intValue
        }

        if let tiredNumber = json.object(forKey: "tired") as? NSNumber {
            tired = tiredNumber.intValue
        }

        if let distractedNumber = json.object(forKey: "distracted") as? NSNumber {
            distracted = distractedNumber.intValue
        }

        if let overwhelmedNumber = json.object(forKey: "overwhelmed") as? NSNumber {
            overwhelmed = overwhelmedNumber.intValue
        }

        if let unhappyNumber = json.object(forKey: "unhappy") as? NSNumber {
            unhappy = unhappyNumber.intValue
        }
        
        note = json.object(forKey: "note") as! String
        
        let createdDateString = json.object(forKey: "created_at") as! String
        createdDate = createdDateString.toIsoDate()
    
    }
}
