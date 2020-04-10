//
//  Session.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation

class Session: NSObject {
    
    var lessonId:String = "0"
    var userId:String = "0"
    var data:[Double] = [Double]()
    var hrData:[Double] = [Double]()
    var dataStr:String = ""
    var hrDataStr:String = ""
    var time:String = "0"
    var dateCreated:Date = Date()
    var reduction:Double = 0.0
    
    override init(){
        super.init()
    }
    
    init(aTime:String, aData:[Double], hData:[Double], lesson:Lesson?, aReduction:Double){
        super.init()
        time = aTime
        reduction = aReduction;
        userId = UserManager.sharedInstance.currentUser.userId
        if(lesson == nil){
            lessonId = "0"
        }else{
            lessonId = lesson!.lessonId
        }
        for num in aData {
            if(dataStr.characters.count == 0){
                dataStr = String(num*10)
            }else{
                dataStr = dataStr + "," + String(num*10)
            }
        }
        data = aData
        hrData = []
        hrDataStr = ""
    }
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        if let l = json.object(forKey: "lesson_id") as? Int {
            lessonId = String(l)
        }
        userId = String(json.object(forKey: "user_id") as! Int)
        
        let createdDateString = json.object(forKey: "created_at") as! String
        dateCreated = createdDateString.toIsoDate()
        
        if let d = json.object(forKey: "data") as? String {
            dataStr = d
            let dataStrArray = dataStr.components(separatedBy: ",")
            for dStr in dataStrArray{
                if let value = Double(dStr) {
                    data.append(value)
                }
            }
        }
        
        hrData = []
        hrDataStr = ""
        
//        if let hd = json.object(forKey: "hr_data") as? String {
//            hrDataStr = hd
//            let hDataStrArray = hrDataStr.components(separatedBy: ",")
//            for hdStr in hDataStrArray{
//                if let hvalue = Double(hdStr) {
//                    hrData.append(hvalue)
//                }
//            }
//        }

        if let t = json.object(forKey: "time") as? Int {
            time = String(t)
        }
        
        if let red = json.object(forKey: "reduction") as? Double{
            reduction = red;
        }
    }
    
    func dataForUploading() -> [String: String] {
        return ["lesson_id":lessonId, "user_id":userId, "data":dataStr, "time":time, "reduction":String(reduction), "hr_data": hrDataStr]
    }
}
