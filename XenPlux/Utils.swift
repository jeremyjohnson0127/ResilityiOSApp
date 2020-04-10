//
//  Utils.swift
//  XenPlux
//
//  Created by diana on 8/10/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class Utils{
    
    public static func getSensorName(_ deviceName:String) -> String
    {
        let nameArray = deviceName.components(separatedBy: " ")
        if nameArray.count > 0{
            if nameArray[0] == "MuscleBAN"{
                return "Muscle Activity Sensor"
            }
        }
        return deviceName
    }

}
