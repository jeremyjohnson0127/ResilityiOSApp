//
//  DatalogUtil.swift
//  XenPlux
//
//  Created by rockstar on 3/20/19.
//  Copyright © 2019 MbientLab Inc. All rights reserved.
//

import UIKit

class DatalogUtil: NSObject {
    
    public static func getPercentsFromDataLog(_ datalog: [Double]) -> Double{
        let fifth = Int(datalog.count/5);
        let firstPart = datalog.prefix(through: fifth);
        let lastPart = datalog.suffix(fifth+1);
        var firstAvg = 0.0
        for num in firstPart {
            firstAvg += num
        }
        firstAvg = firstAvg/Double(fifth)
        var lastAvg = 0.0
        for num in lastPart {
            lastAvg += num
        }
        lastAvg = lastAvg/Double(fifth)
        let increase = firstAvg < lastAvg
        return 100.0 - (increase ? (100) : ((lastAvg/firstAvg)*100.0))
    }
    
    public static func getHRDecrease(_ datalog: [Double]) -> Double{
        let fifth = Int(datalog.count/5);
        let firstPart = datalog.prefix(through: fifth);
        let lastPart = datalog.suffix(fifth+1);
        var firstAvg = 0.0
        for num in firstPart {
            firstAvg += num
        }
        firstAvg = firstAvg/Double(fifth)
        var lastAvg = 0.0
        for num in lastPart {
            lastAvg += num
        }
        lastAvg = lastAvg/Double(fifth)
        return firstAvg - lastAvg
    }

    
    public static func increased(_ datalog: [Double]) -> Bool{
        let fifth = Int(datalog.count/5);
        let firstPart = datalog.prefix(through: fifth);
        let lastPart = datalog.suffix(fifth+1);
        var firstAvg = 0.0
        for num in firstPart {
            firstAvg += num
        }
        firstAvg = firstAvg/Double(fifth)
        var lastAvg = 0.0
        for num in lastPart {
            lastAvg += num
        }
        lastAvg = lastAvg/Double(fifth)
        return firstAvg < lastAvg
    }
    
    public static func notEnoughData(_ datalog: [Double]) -> Bool{
        let fifth = Int(datalog.count/5);
        if(fifth == 0){
            return true;
        }
        return false;
    }
}
