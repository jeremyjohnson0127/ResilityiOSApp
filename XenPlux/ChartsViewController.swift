import UIKit
import Charts

class ChartsViewController: BaseViewController {
    
//    @IBOutlet weak var lineChartView: LineChartView!
//    @IBOutlet weak var pieChartView: PieChartView!

    @IBOutlet weak var lineChartView: LineChartView!
    var data: [Double]!
    var dataLog: [Double]!
    var xValues: [String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLog = data
        print(dataLog)
        // Do any additional setup after loading the view.
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
//        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
//        for i in 0..<dataLog.count{
//            xValues.append("a")
//        }
        setChart(months, values: dataLog)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setChart(_ dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<values.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Tension")
        let lineChartData = LineChartData(dataSet: lineChartDataSet)

        lineChartView.data = lineChartData
        
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.circleRadius = 0
        lineChartDataSet.setColor(UIColor.blue.withAlphaComponent(0.8))
        
//        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawFilledEnabled = true
//        lineChartDataSet.fillColor = UIColor(red: CGFloat(0/255), green: CGFloat(128/255), blue: CGFloat(255/255), alpha: 1)
        lineChartDataSet.fillColor = UIColor.blue.withAlphaComponent(0.6)

        
        lineChartView.data?.setDrawValues(false)
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false

        
        lineChartView.drawGridBackgroundEnabled = false
        
        lineChartView.chartDescription?.text = ""
        lineChartView.noDataText = ""
        
        lineChartView.xAxis.drawAxisLineEnabled = false
        lineChartView.xAxis.drawLimitLinesBehindDataEnabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        
        lineChartView.leftAxis.removeAllLimitLines()
        lineChartView.leftAxis.drawZeroLineEnabled = false
        lineChartView.leftAxis.zeroLineWidth = 0
        lineChartView.leftAxis.drawTopYLabelEntryEnabled = false
        lineChartView.leftAxis.drawAxisLineEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawLimitLinesBehindDataEnabled = false

        lineChartView.rightAxis.removeAllLimitLines()
        lineChartView.rightAxis.drawZeroLineEnabled = false
        lineChartView.leftAxis.zeroLineWidth = 0
        lineChartView.rightAxis.drawTopYLabelEntryEnabled = false
        lineChartView.rightAxis.drawAxisLineEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLimitLinesBehindDataEnabled = false
//        yAxis.drawGridLinesEnabled = false
    }
    
}
