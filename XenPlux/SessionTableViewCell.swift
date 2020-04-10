//
//  SessionTableViewCell.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import Charts

class SessionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var reductionLbl: UILabel!
    @IBOutlet weak var bgRoundedView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var lessonLbl: UILabel!
    @IBOutlet weak var chart: UIView!
//    var chart2: Chart = Chart();
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setSession(session:Session)->Void{

        bgRoundedView.layer.cornerRadius = 10
        bgRoundedView.layer.shadowColor = UIColor.gray.cgColor
        bgRoundedView.layer.shadowOpacity = 0.25
        bgRoundedView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgRoundedView.layer.shadowRadius = 5
        
//        chart2.removeFromSuperview()
////        chart2 = Chart(frame: CGRect(origin: CGPoint.zero, size: chart.frame.size))
//        chart2 = Chart()
//        chart2.translatesAutoresizingMaskIntoConstraints = false
//
//        chart.addSubview(chart2)
//        chart2.bindFrameToSuperviewBounds()
        
//        var fAr = [Float]()
//        for dItem in session.data{
//            fAr.append(Float(dItem))
//        }
//        let series = ChartSeries(fAr)
//        series.area = true;
        
//        chart2.add(series)
//        chart2.labelColor = UIColor.clear
        
        if session.reduction == 0 {
            reductionLbl.text = "No Tension Data"
        } else {
            reductionLbl.text = String(format:"%0.2f",session.reduction) + "% Tension Reduction"
        }
        lessonLbl.text = "Monitoring Session"
        if(LessonManager.sharedInstance.lessons.count == 0){
            LessonManager.sharedInstance.getLessons(success: { (lessons: [Lesson]) in
                self.loadLesson(session: session)
            }, failure: { (error:Error?) in
                
            })
        }

        loadLesson(session: session)
        dateLbl.text = session.dateCreated.toTimeString()
        timeLbl.text = NSString(format: "%.01f", (Float(session.time)!/60)) as String
    }
    
    func loadLesson(session: Session){
        for lesson in LessonManager.sharedInstance.lessons{
            if(session.lessonId == lesson.lessonId){
                lessonLbl.text = lesson.name
            }
        }
    }

//    override func draw(_ rect: CGRect, for formatter: UIViewPrintFormatter) {
//        chart2.frame = chart.frame
//    }
}
