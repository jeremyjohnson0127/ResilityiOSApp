//
//  Activity.swift
//  XenPlux
//
//  Created by rockstar on 10/19/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import Foundation

class Activity: NSObject {
    
    var activityType: String = ""
    var data:[Double] = [Double]()
    var dateCreated:Date = Date()
    var reduction:Double = 0.0
    var checkinNote: String = ""
    var dataStr:String = ""
    var lessonId:String = "0"
    var isAllView:Bool = false

    override init(){
        super.init()
    }
    
    init(session: Session, isTraining:Bool){
        super.init()
        if isTraining {
            self.activityType = ActivityType.training.rawValue
        }else{
            self.activityType = ActivityType.monitoring.rawValue
        }
        self.data = session.data
        self.dataStr = session.dataStr
        self.dateCreated = session.dateCreated
        self.reduction = session.reduction
        self.lessonId = session.lessonId
    }
    
    init(checkin:Checkins){
        self.activityType = ActivityType.checkin.rawValue
        self.dateCreated = checkin.createdDate
        self.checkinNote = checkin.note
        self.isAllView = checkin.isAllView
    }
}

enum ActivityType: String
{
    case training,
    monitoring,
    checkin
    
    init()
    {
        self = .training
    }
}
