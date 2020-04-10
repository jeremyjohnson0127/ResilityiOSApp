//
//  Survey.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation

class Survey: NSObject {
    
    var surveyId:String = "0"
    var name:String = ""
    var details:String = ""
    var surveyQuestions:[SurveyQuestion] = [SurveyQuestion]()
    
    override init() {
        super.init()
    }
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        if let l = json.object(forKey: "id") as? Int {
            surveyId = String(l)
        }
        name = json.object(forKey: "name") as! String
        details = json.object(forKey: "details") as! String
        let jsonQAr = json.object(forKey: "SurveyQuestions") as! NSArray
        for jsonQ in jsonQAr {
            let q = SurveyQuestion(json: jsonQ as! NSDictionary)
            surveyQuestions.append(q)
        }
    }
}
