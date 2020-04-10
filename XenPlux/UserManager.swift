//
//  UserManager.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation
import Alamofire
import OneSignal

class UserManager: NSObject {
    public static let sharedInstance = UserManager()
    var currentUser:User = User()
    
    func validateToken(tokenValid:@escaping (Bool) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]

        headers = Helper.authHeaders(headers: headers);

        // Fetch Request
        Alamofire.request(BASE_URL+"/auth/validate_token", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let JSON = response.result.value as? NSDictionary {

                        
                        self.currentUser = User(json: JSON.object(forKey: "data") as! NSDictionary)
                        self.sendUserDataToOnesignal()
                        tokenValid(true)
                        return
                    }
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                tokenValid(false)
        }
    }
    
    func login(userName:String, password:String, success:@escaping ((User) -> Void), failure:@escaping ((String?) -> Void) ) -> Void{
        
        let url = URL(string:BASE_URL+"/auth/sign_in")
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: url!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        
        /**
         Login
         POST http://localhost:3000/api/v1/auth/sign_in
         */
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json",
            ]
        
        // JSON Body
        let body = [
            "email": userName,
            "password": password
        ]
        
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.synchronize()
        // Fetch Request
        Alamofire.request(url!.absoluteString, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    debugPrint("HTTP Response Body: \(response.data)")
                    if let JSON = response.result.value as? NSDictionary {
                        //save token info
                        let header = response.response!.allHeaderFields
                        let ud = UserDefaults.standard
                        
                        //Local uses lowercase. TODO: Figure out why...
//                        ud.set(header["expiry"], forKey: "expiry")
//                        ud.set(header["uid"], forKey: "uid")
//                        ud.set(header["access-token"], forKey: "access-token")
//                        ud.set(header["client"], forKey: "client")
                        ud.set(header["Expiry"], forKey: "expiry")
                        ud.set(header["Uid"], forKey: "uid")
                        ud.set(header["Access-Token"], forKey: "access-token")
                        ud.set(header["Client"], forKey: "client")
                        ud.synchronize()

                        let token = UserDefaults.standard.string(forKey: "access-token")
                        self.currentUser = User(json: JSON.object(forKey: "data") as! NSDictionary)
                        self.sendUserDataToOnesignal()
                        success(self.currentUser)
                        return
                    }
                }
                else {
                    debugPrint("HTTP Request failed: \(response.result.error)")
                }
                failure(response.result.error?.localizedDescription);
        }
    }
    
    func createAccount(name:String, userName:String, password:String, success:@escaping ((User) -> Void), failure:@escaping ((String?) -> Void) ) -> Void{
        let url = URL(string: HOST+"/users")
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: url!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        
        /**
         Login
         POST http://localhost:3000/api/v1/auth/sign_in
         */
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json",
            ]
        
        // JSON Body
        let body = ["user":
            [
                "name": name,
                "email": userName,
                "password": password,
                "platform": "iOS"
            ]
        ]
        
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.synchronize()
        // Fetch Request
        Alamofire.request(url!.absoluteString, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    self.login(userName: userName, password: password, success: success, failure: failure);
                    return;
                }
                else {
                    if response.response?.statusCode == 422{
                        let json = String(data: response.data!, encoding: String.Encoding.utf8);
                        if json == "{\"email\":[\"already in use\"]}"{
                            failure("Email was already used.")
                        }else{
                            failure("There was a problem creating your account. Please try again.");
                        }
                    }else{
                        failure("There was a problem creating your account. Please try again.");
                    }
                }
        }
    }
    
    func resetPassword(userName:String, success:@escaping (() -> Void), failure:@escaping ((Error?) -> Void) ) -> Void{
        
        let url = URL(string:HOST+"/users/password")
        let cstorage = HTTPCookieStorage.shared
        if let cookies = cstorage.cookies(for: url!) {
            for cookie in cookies {
                cstorage.deleteCookie(cookie)
            }
        }
        
        // Add Headers
        let headers = [
            "Content-Type":"application/json",
            ]
        
        // JSON Body
        let body = ["user":
            [
                "email": userName
            ]
        ]
        
        // Fetch Request
        Alamofire.request(url!.absoluteString, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    success();
                    return;
                }
                else {
                }
                failure(response.result.error);
        }
    }
    
    func sendUserDataToOnesignal(){
        OneSignal.sendTags(["user_id":currentUser.userId, "user_name":currentUser.name, "email":currentUser.email, "group_name":currentUser.groupName])
    }
    
    func saveUserDevice(success:@escaping (String) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        var headers = ["Content-Type":"application/json"]
        headers = Helper.authHeaders(headers: headers);
        let body = ["platform":"iOS"]
        let url = BASE_URL+"/users/platform"
        Alamofire.request(url, method: .post, parameters:body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    success("iOS")
                }
                failure(response.result.error)
        }
    }

}
