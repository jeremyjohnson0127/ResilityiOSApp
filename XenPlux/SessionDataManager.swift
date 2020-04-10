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

class SessionManager: NSObject {
    public static let sharedInstance = SessionManager()
    var sessions = [Session]()
    var currentSession = Session()
    
    func getSessions(success:@escaping ([Session]) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var tempSessions = [Session]()
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        
        // Fetch Request
        let url = BASE_URL+"/sessions/for_user/"+UserManager.sharedInstance.currentUser.userId
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let sessionJSON = response.result.value as? NSArray {
                        for sessionObj in sessionJSON{
                            let session = Session(json: sessionObj as! NSDictionary)
                            tempSessions.append(session)
                        }
                        tempSessions = tempSessions.sorted(by: { (s1:Session, s2:Session) -> Bool in
                            return s1.dateCreated > s2.dateCreated
                        })
                        success(tempSessions)
                        return
                    }
                }
                failure(response.result.error)
        }
    }
    
    func createSession(session:Session, success:@escaping (String) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        let data = session.dataForUploading()
        
        // Fetch Request
        let url = BASE_URL+"/sessions"
        Alamofire.request(url, method: .post, parameters:data, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let respJson = response.result.value as? NSDictionary {
                        success(String(respJson.object(forKey: "id") as! Int))
                        return
                    }
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                failure(response.result.error)
        }
    }
    
}
