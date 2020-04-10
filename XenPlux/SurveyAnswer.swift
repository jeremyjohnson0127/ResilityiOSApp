//
//  SurveyAnswers.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/30/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation
class SurveyAnswer: NSObject {
    var answer:String = ""
    var answerId:String = "0"
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        if let l = json.object(forKey: "id") as? Int {
            answerId = String(l)
        }
        answer = json.object(forKey: "answer") as! String

    }
}
