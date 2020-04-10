//
//  Lesson.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import OneSignal

class Lesson: NSObject {
    
    var name = ""
    var details = ""
    var streamingURL = ""
    var length = 0
    var lessonId = "0"
    var ordinal = 0
    var instructionLink = "";
    var isFavorite = false
    
    override init(){
        super.init()
    }
    
    init(json: NSDictionary){
        super.init()
        loadFromJSON(json: json)
    }
    
    func loadFromJSON(json: NSDictionary){
        name = json.object(forKey: "name") as! String
        details = json.object(forKey: "details") as! String
        lessonId = String(json.object(forKey: "id") as! Int)
        ordinal = json.object(forKey: "ordinal") as! Int
        
        if let iLink = json.object(forKey: "instructionLink") as? String {
            instructionLink = iLink;
        }
        
        if let surl = json.object(forKey: "streamingUrl") as? String {
            streamingURL = surl
        }

    }
    
    func downloadName() -> String{
        let name = streamingURL.replacingOccurrences(of: "/", with: "").replacingOccurrences(of: ":", with: "").replacingOccurrences(of: "+", with: "").replacingOccurrences(of: ".", with: "") + ".mp3"
        
        return name;
    }
    
    func setLessonCompleted(completed: Bool) -> Void{
        UserDefaults.standard.set(completed, forKey: downloadName())
        OneSignal.sendTags(["last_lesson_id":lessonId, "last_lesson_ordinal":ordinal, "last_lesson_name":name, "last_lesson_date":NSDate().timeIntervalSince1970])
        UserDefaults.standard.synchronize()
    }
    
    func isLessonCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: downloadName())
    }
    
}
