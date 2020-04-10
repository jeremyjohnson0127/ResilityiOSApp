//
//  CheckinDataManager.swift
//  XenPlux
//
//  Created by rockstar on 8/20/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import Alamofire

class CheckinDataManager: NSObject {
    
    public static let sharedInstance = CheckinDataManager()

    func saveLastCheckInDate(){
        let date = Date().toDateString()
        UserDefaults.standard.set(date, forKey: "lastDate")
        UserDefaults.standard.synchronize()
    }
    
    func isTodayCheckedIn() -> Bool{
        let lastDateString = UserDefaults.standard.string(forKey: "lastDate")
        let currentDateString = Date().toDateString()
        if lastDateString == currentDateString{
            return true
        }else{
            return false
        }
    }
    
    func createCheckIn(checkIn:Checkins, success:@escaping (String) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        var headers = ["Content-Type":"application/json"]
        headers = Helper.authHeaders(headers: headers);
        let data = checkIn.dataForUploading()
        let url = BASE_URL+"/user_checkins"
        Alamofire.request(url, method: .post, parameters:data, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let respJson = response.result.value as? NSDictionary {
                        success(String(respJson.object(forKey: "id") as! Int))
                        return
                    }
                }
                else {
                }
                failure(response.result.error)
        }
    }
    
    func getCheckIns(success:@escaping ([Checkins]) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var checkIns = [Checkins]()
        var headers = ["Content-Type":"application/json"]
        headers = Helper.authHeaders(headers: headers);
        
        Alamofire.request(BASE_URL+"/user_checkins", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let checkInJSON = response.result.value as? NSArray {
                        for checkInObj in checkInJSON{
                            let checkIn = Checkins(json: checkInObj as! NSDictionary)
                            checkIns.append(checkIn)
                        }
                        success(checkIns)
                        return
                    }
                }
                else {
                }
                failure(response.result.error)
        }
    }


    
}
