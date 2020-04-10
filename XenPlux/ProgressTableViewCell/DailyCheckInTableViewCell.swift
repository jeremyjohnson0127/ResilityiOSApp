//
//  DailyCheckInTableViewCell.swift
//  XenPlux
//
//  Created by rockstar on 8/24/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import Charts

class DailyCheckInTableViewCell: UITableViewCell{

    private let ITEM_COUNT = 10

    @IBOutlet weak var chartView: CombinedChartView!
    
    var allCheckIns = [Checkins]()
    var weekDayStrings = [String]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCombinedChartView(_ checkIns: [Checkins],_ selectedPage : Date){
        self.allCheckIns = checkIns
        self.weekDayStrings = selectedPage.getWeekDayStrings()
        initChartView()
    }
    
    func initChartView(){
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        
        chartView.drawOrder = [DrawOrder.bar.rawValue,
                               DrawOrder.bubble.rawValue,
                               DrawOrder.candle.rawValue,
                               DrawOrder.line.rawValue,
                               DrawOrder.scatter.rawValue]
        
        let l = chartView.legend
        l.wordWrapEnabled = true
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        //        chartView.legend = l
        
        let rightAxis = chartView.rightAxis
        rightAxis.axisMinimum = 0
        rightAxis.drawAxisLineEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawLabelsEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.axisMinimum = 0
        leftAxis.labelCount = 10
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawLabelsEnabled = false

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bothSided
        xAxis.axisMinimum = -0.5
        xAxis.granularity = 1
        xAxis.valueFormatter = self
        
        self.chartView.xAxis.drawGridLinesEnabled = true
        self.chartView.leftAxis.drawLabelsEnabled = false
        self.chartView.legend.enabled = false

        self.setChartData()
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()

        chartView.xAxis.axisMaximum = data.xMax + 0.25
        chartView.data = data
    }

    func generateLineData() -> LineChartData {
        let maxCount = self.weekDayStrings.count - 1
        let entries = (0..<self.weekDayStrings.count).map { (i) -> ChartDataEntry in
            let weekDayString = self.weekDayStrings[i]
            var dayCheckins = [Checkins]()
            for checkIn in allCheckIns{
                if checkIn.createdDate.toString2() == weekDayString{
                    dayCheckins.append(checkIn)
                }
            }
            return self.getAverageValueLineChartDataEntry(dayCheckins, xValue: (maxCount-i))
        }
        
        let set = LineChartDataSet(values: entries, label: "")
        set.setColor(UIColor.lineChartColor)
        set.lineWidth = 2.5
        set.setCircleColor(UIColor.lineChartColor)
        set.circleRadius = 7.5
        set.circleHoleRadius = 3.5
        set.fillColor = UIColor.white
        set.mode = .cubicBezier
        set.drawValuesEnabled = true
        set.valueFont = .systemFont(ofSize: 0)
        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateBarData() -> BarChartData {
        let maxCount = self.weekDayStrings.count - 1

        let entries2 = (0..<self.weekDayStrings.count).map { (i) -> BarChartDataEntry in
            let weekDayString = self.weekDayStrings[i]
            var dayCheckins = [Checkins]()
            for checkIn in allCheckIns{
                if checkIn.createdDate.toString2() == weekDayString{
                    dayCheckins.append(checkIn)
                }
            }
            return self.getAverageValueBarChartDataEntry(dayCheckins, xValue: (maxCount-i))
        }
        
        
        let set2 = BarChartDataSet(values: entries2, label: "")
        set2.stackLabels = ["Stack 1", "Stack 2"]
        set2.colors = [UIColor.barChart1Color,
                       UIColor.barChart2Color,
                       UIColor.barChart3Color,
                       UIColor.barChart4Color,
                       UIColor.barChart5Color
        ]
        set2.valueTextColor = UIColor(red: 61/255, green: 165/255, blue: 255/255, alpha: 1)
        set2.valueFont = .systemFont(ofSize: 0)
        set2.axisDependency = .left
        
        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.3
        // (0.45 + 0.02) * 2 + 0.06 = 1.00 -> interval per "group"
        
        let data = BarChartData(dataSets: [ set2])

        data.barWidth = barWidth
        
        // make this BarData object grouped
        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        
        return data
    }
    
    func getAverageValueLineChartDataEntry(_ checkins:[Checkins], xValue:Int) -> ChartDataEntry{
        
        let count =  checkins.count
        if count == 0{
            return ChartDataEntry(x: Double(xValue), y: Double(0))
        }else{
            
            var tenseSum = 0
            var tiredSum = 0
            var distractedSum = 0
            var overwhelmedSum = 0
            var unhappySum = 0
            
            for checkin in checkins{
                tenseSum += checkin.tense
                tiredSum += checkin.tired
                distractedSum += checkin.distracted
                overwhelmedSum += checkin.overwhelmed
                unhappySum += checkin.unhappy
            }
            let yValue = Double(tenseSum/count) + Double(tiredSum/count) + Double(distractedSum/count) + Double(overwhelmedSum/count) + Double(unhappySum/count)
            return ChartDataEntry(x: Double(xValue), y: yValue)
        }
        
    }

    
    func getAverageValueBarChartDataEntry(_ checkins:[Checkins], xValue:Int) -> BarChartDataEntry{
        
        let count =  checkins.count
        if count == 0{
            return BarChartDataEntry(x: Double(xValue), yValues: [0.0,0.0,0.0,0.0,0.0])
        }else{
            
            var tenseSum = 0
            var tiredSum = 0
            var distractedSum = 0
            var overwhelmedSum = 0
            var unhappySum = 0
            
            for checkin in checkins{
                tenseSum += checkin.tense
                tiredSum += checkin.tired
                distractedSum += checkin.distracted
                overwhelmedSum += checkin.overwhelmed
                unhappySum += checkin.unhappy
            }
            return BarChartDataEntry(x: Double(xValue), yValues: [Double(tenseSum/count),Double(tiredSum/count),Double(distractedSum/count),Double(overwhelmedSum/count),Double(unhappySum/count)])
        }

    }
}

extension DailyCheckInTableViewCell: ChartViewDelegate {
    // TODO: Cannot override from extensions
    //extension DemoBaseViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}


extension DailyCheckInTableViewCell: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
}

