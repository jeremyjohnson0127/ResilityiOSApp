//
//  Helper.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import Foundation
import Alamofire

class Helper: NSObject {
    
    
    static func showSimpleError(vc: UIViewController, title: String, message: String) -> Void{
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil));
        
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func showSimpleError(vc: UIViewController, title: String, message: String, callback:@escaping () -> Void) -> Void{
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        ac.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (action:UIAlertAction) in
            callback()
        }));
        
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func showSimpleYesNoError(vc: UIViewController, title: String, message: String, callBack:@escaping (Bool)->Void) -> Void{
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { (action:UIAlertAction) in
            callBack(true)
        }));
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            callBack(false)
        }));
        
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func showSimpleYesNoAlert(vc: UIViewController, title: String, message: String, callBack:@escaping (Bool)->Void) -> Void{
        let ac = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert);
        ac.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            callBack(false)
        }));
        ac.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action:UIAlertAction) in
            callBack(true)
        }));
        
        vc.present(ac, animated: true, completion: nil)
    }
    
    static func authHeaders(headers: [String: String]) -> HTTPHeaders{
        let sf = UserDefaults.standard
        // Add Headers
        var headers_new:HTTPHeaders? = headers
        
        let expiry = sf.string(forKey: "expiry")!
        let uid = sf.string(forKey: "uid")!
        let at = sf.string(forKey: "access-token")!
        let client = sf.string(forKey: "client")!
        
        headers_new!.update(other: [
            "expiry":expiry,
            "uid":uid,
            "access-token":at,
            "token-type":"Bearer",
            "client": client
            ]);
        
        return headers_new!
    }
    
    static func clearToken() -> Void {
        let ud = UserDefaults.standard
        
        ud.removeObject(forKey: "expiry")
        ud.removeObject(forKey: "uid")
        ud.removeObject(forKey: "access-token")
        ud.removeObject(forKey: "client")
//        ud.removeObject(forKey: "userName")
        
        ud.synchronize()
        
    }
}
