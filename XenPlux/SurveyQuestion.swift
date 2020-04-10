//
//  SurveyQuestion.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation

class SurveyQuestion: NSObject {
    var questionId:String = "0"
    var question:String = ""
    var answers:[SurveyAnswer] = [SurveyAnswer]()
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        if let l = json.object(forKey: "id") as? Int {
            questionId = String(l)
        }
        question = json.object(forKey: "question") as! String
        if let l = json.object(forKey: "SurveyAnswers") as? NSArray {
            for answer in l {
                answers.append(SurveyAnswer(json: answer as! NSDictionary))
            }
        }
    }
}
