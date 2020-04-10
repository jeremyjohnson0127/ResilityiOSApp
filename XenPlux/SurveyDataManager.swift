//
//  SessionDataManager.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

//
//  LessonManager.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import Alamofire

class SurveyManager: NSObject {
    public static let sharedInstance = SurveyManager()
    var shortSurvey:Survey = Survey()
    var longSurvey:Survey = Survey()
    
    func getLongSurvey(success:@escaping (Survey) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        
        // Fetch Request
        let url = BASE_URL+"/surveys/long_survey"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let surveyjson = response.result.value as? NSDictionary {
                        
                        let survey = Survey(json: surveyjson)
                        success(survey)
                        return
                    }
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                failure(response.result.error)
        }
    }
    
    func getShortSurvey(success:@escaping (Survey) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        
        // Fetch Request
        let url = BASE_URL+"/surveys/short_survey"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let surveyjson = response.result.value as? NSDictionary {
                        
                        let survey = Survey(json: surveyjson)
                        success(survey)
                        return
                    }
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                failure(response.result.error)
        }
    }
    
    func uploadSurveyResponses(responsesString:String, responses:[[String:String]], sessionId:String, surveyId:String, success:@escaping () -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        let data = ["responses": responsesString, "session_id": sessionId, "survey_id": surveyId, "user_id": UserManager.sharedInstance.currentUser.userId, "survey_response_answers_attributes" : responses] as [String : Any]
        
        // Fetch Request
        let url = BASE_URL+"/surveys/response"
        Alamofire.request(url, method: .post, parameters:data, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    success()
                    return
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                failure(response.result.error)
        }
    }
    
}
