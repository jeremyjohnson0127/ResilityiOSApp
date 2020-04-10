//
//  LessonManager.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class LessonManager: NSObject {
    public static let sharedInstance = LessonManager()
    var lessons = [Lesson]()
    var favoriteLesssons = [Lesson]()

    var currentLesson:Lesson?

    func getLessons(success:@escaping ([Lesson]) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        lessons = [Lesson]()
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        
        // Fetch Request
        Alamofire.request(BASE_URL+"/lessons", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let lessonJSON = response.result.value as? NSArray {
                        //save token info
//                        let header = response.response!.allHeaderFields
//                        let ud = UserDefaults.standard
//                        ud.set(header["Expiry"], forKey: "expiry")
//                        ud.set(header["Uid"], forKey: "uid")
//                        ud.set(header["Access-Token"], forKey: "access-token")
//                        ud.set(header["Client"], forKey: "client")
//                        ud.synchronize()
                        for lessonObj in lessonJSON{
                            let lesson = Lesson(json: lessonObj as! NSDictionary)
                            self.lessons.append(lesson)
                        }
                        success(self.lessons)
                        return
                    }
                }
                else {
                }
                failure(response.result.error)
        }
    }
    
    func getFavorites(success:@escaping ([Lesson]) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        favoriteLesssons = [Lesson]()

        // Add Headers
        var headers = ["Content-Type":"application/json"]
        headers = Helper.authHeaders(headers: headers);
        // Fetch Request
        Alamofire.request(BASE_URL+"/user_favorites", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    if let lessonJSON = response.result.value as? NSArray {
                        for lessonObj in lessonJSON{
                            let lesson = Lesson(json: lessonObj as! NSDictionary)
                            self.favoriteLesssons.append(lesson)
                        }
                        success(self.favoriteLesssons)
                        return
                    }
                }
                else {
                }
                failure(response.result.error)
        }
    }

    
    func isLessonDownloaded(lesson: Lesson) -> Bool {
        let name = lesson.downloadName()
        var documentsURL = self.getLessonsPath()
        documentsURL.appendPathComponent(name)
        
        let exists = FileManager.default.fileExists(atPath: documentsURL.path)
        return exists
    }
    
    func downloadLesson(lesson: Lesson, callback:@escaping (_ success: Bool, _ url: URL)->Void, progressCallback:@escaping (_ progress:Double)->Void) -> Void {
        let name = lesson.downloadName()
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = self.getLessonsPath()
            documentsURL.appendPathComponent(name)
            return (documentsURL, [.removePreviousFile])
        }
        
        var hud = MBProgressHUD()
        
        Alamofire.download(
            lesson.streamingURL,
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                progressCallback(progress.fractionCompleted);
            }).response(completionHandler: { (DefaultDownloadResponse) in
               
                callback(DefaultDownloadResponse.error != nil, DefaultDownloadResponse.destinationURL!)
            })
    }
    
    func getLessonsPath() -> URL{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("lessons")
        do{
            try FileManager.default.createDirectory(at: documentsURL, withIntermediateDirectories: true, attributes: nil);
        }catch{}
        return documentsURL;
    }
    
    func createFavorite(lesson:Lesson, success:@escaping (String) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        // Add Headers
        var headers = [
            "Content-Type":"application/json",
            ]
        
        headers = Helper.authHeaders(headers: headers);
        let data = ["lesson_id":lesson.lessonId]
        // Fetch Request
        let url = BASE_URL+"/user_favorites"
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
    
    func deleteFavorite(lesson:Lesson, success:@escaping (String) -> Void, failure:@escaping (Error?) -> Void) -> Void{
        var headers = ["Content-Type":"application/json"]
        headers = Helper.authHeaders(headers: headers);
        let data = ["lesson_id":lesson.lessonId]
        let url = BASE_URL+"/user_favorites/delete"
        Alamofire.request(url, method: .post, parameters:data, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    success("")
                    return
                }else{
                    failure(response.result.error)
                }
        }
    }
}
