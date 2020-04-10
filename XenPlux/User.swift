//
//  Users.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name = ""
    var email = ""
    var userId = "0"
    var groupName = ""
    var showLongSurvey = true;
    var deviceType = "iOS"
    
    override init(){
        super.init()
    }
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        name = json.object(forKey: "name") as! String
        email = json.object(forKey: "email") as! String
        userId = String(json.object(forKey: "id") as! Int)
        showLongSurvey = json.object(forKey: "show_long_survey") as! Bool
        groupName = json.object(forKey: "group_name") as! String
    }
}
