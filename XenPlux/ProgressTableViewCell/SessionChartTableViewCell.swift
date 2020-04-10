//
//  SessionChartTableViewCell.swift
//  XenPlux
//
//  Created by rockstar on 8/25/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import Charts

private class CubicLineSampleFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return -10
    }
}

class SessionChartTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var descLabel: UILabel!

    @IBOutlet var chartView: LineChartView!
    
    var sessionData:[Double] = [Double]()
    var isTraining: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSessionView(_ activity: Activity){
        if activity.activityType == ActivityType.monitoring.rawValue{
            nameLabel.text = "Monitoring Session"
            isTraining = false
        }else{
            isTraining = true
            if(LessonManager.sharedInstance.lessons.count == 0){
                LessonManager.sharedInstance.getLessons(success: { (lessons: [Lesson]) in
                    self.loadLesson(activity: activity)
                }, failure: { (error:Error?) in

                })
            }else{
                self.loadLesson(activity: activity)
            }
        }
        
        
        timeLabel.text = activity.dateCreated.toTimeString()
        if activity.reduction == 0 {
            descLabel.text = "No Tension Data"

        } else {
            descLabel.text = String(format:"%0.2f",activity.reduction) + "% Tension Reduction"
        }
        sessionData = activity.data
        DispatchQueue.main.async {
            self.initChartView()
        }
    }

    
    func loadLesson(activity: Activity){
        for lesson in LessonManager.sharedInstance.lessons{
            if(activity.lessonId == lesson.lessonId){
                nameLabel.text = lesson.name
            }
        }
    }

    
    func initChartView(){
        chartView.delegate = self
        chartView.setViewPortOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.backgroundColor = UIColor.clear
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.maxHighlightDistance = 300
        chartView.xAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size:12)!
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .white
        yAxis.labelPosition = .insideChart
        yAxis.axisLineColor = .white
        yAxis.drawAxisLineEnabled = false
        yAxis.drawGridLinesEnabled = false
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        chartView.legend.enabled = false
        chartView.chartDescription?.text = ""
        self.setDataCount()
    }
    
    func setDataCount() {
        let yVals1 = (0..<sessionData.count).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i), y: sessionData[i])
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "DataSet 1")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        if isTraining{
            set1.fillColor = UIColor.lesson1Color
            set1.highlightColor = UIColor.lesson1Color
        }else{
            set1.fillColor = UIColor.barChart2Color
            set1.highlightColor = UIColor.barChart2Color
        }
        set1.fillAlpha = 1
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.fillFormatter = CubicLineSampleFillFormatter()
        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        chartView.data = data
    }
}

extension SessionChartTableViewCell: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected")
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected")
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
    }
}
