
//
//  DeviceViewController.swift
//  SwiftStarter
//
//  Created by Stephen Schiffli on 10/20/15.
//  Copyright © 2015 MbientLab Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import Bolts
import MessageUI
import GaugeKit
import AVFoundation
import PluxAPI
import ResearchKit
import Charts
class DeviceViewController: BaseViewController, MFMailComposeViewControllerDelegate, PXBioPluxManagerDelegate, ORKTaskViewControllerDelegate, ChartViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var gaugeBGView: UIView!
    @IBOutlet weak var deviceStatus: UILabel!
//    @IBOutlet weak var heartRateLabel: UILabel!

    var mindStartDate: Date!
    var mindEndDate: Date!
    
    var monitoring = false
    var filtering = true as Bool;
    var firstMinute = 0;
    var lastMinute = 0;
    var minSample = 0.25 as Double;
    var maxSample = 26624.0 as Double;
    //    var centralManager = PXBioPluxManager()
    var centralManager: PXBioPluxManager!
    var device: PXDevice!
    var streaming = false;
    var recording = false;
    var button = UIButton();
    var percentage:Double = 0.0;
    
    var audioPlayer = AVPlayer()
    var isPlaying = false
    var audioTimer:Timer!
    var startTime:NSDate = NSDate()
    var hasDevice = false
    var countTimer:Timer = Timer()
    //    var dataLog: [Double] = []
    var dataLog: [Double]! = [Double]()
    var heartRateLog: [Double]! = [Double]()
    
    var timer: Timer!
    var chartTimer: Timer!
    var healthtimer: Timer!

    
    var timeNum = 0
    @IBOutlet weak var threshold: Gauge!
    @IBOutlet weak var voltage: UILabel!
    @IBOutlet var gaugeVoltage: Gauge!
    var mainButtonImage = #imageLiteral(resourceName: "play")
    
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var lineChartView: LineChartView!
    
    @IBOutlet weak var thresholdLabel: UILabel!
    @IBOutlet weak var thresholdSlider: UISlider!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deviceView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gaugeBGView.layer.cornerRadius = gaugeBGView.frame.width * 0.75
        if(LessonManager.sharedInstance.currentLesson == nil){
            titleLabel.text = "Monitor"
            monitoring = true;
            mainButtonImage = #imageLiteral(resourceName: "record")
            playButton.setImage(mainButtonImage, for: UIControlState.normal)
            
            lineChartView.isHidden = false;
            threshold.isHidden = false;
            thresholdLabel.isHidden = false;
            thresholdSlider.isHidden = false;
            gaugeVoltage.isHidden = false;

        }else{
            titleLabel.text = LessonManager.sharedInstance.currentLesson!.name
            monitoring = false
            
            lineChartView.isHidden = true;
            threshold.isHidden = true;
            gaugeVoltage.isHidden = true;
            thresholdLabel.isHidden = true;
            thresholdSlider.isHidden = true;
        }
        
        checkForSurveyNeed()
        if(LessonManager.sharedInstance.currentLesson != nil){
            if(LessonManager.sharedInstance.currentLesson!.instructionLink.count > 0){
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InstructionViewController") as! UINavigationController
                (vc.viewControllers[0] as! InstructionViewController).lesson = LessonManager.sharedInstance.currentLesson!
                self.navigationController!.tabBarController!.present(vc, animated: true, completion: nil)
            }
        }
        
        var dataEntries: [ChartDataEntry] = []
        
        let dataEntry = ChartDataEntry(x: Double(0), y: Double(5))
        dataEntries.append(dataEntry)
        
        //charts
        self.lineChartView.delegate = self
        let set_a: LineChartDataSet = LineChartDataSet(values: dataEntries, label: "")
        set_a.drawCirclesEnabled = false
        set_a.drawValuesEnabled = false
        set_a.drawFilledEnabled = true
        set_a.mode = LineChartDataSet.Mode.horizontalBezier
        set_a.setColor(UIColor.lesson1Color)
        
        self.lineChartView.data = LineChartData(dataSets: [set_a])
        self.lineChartView.backgroundColor = UIColor.clear
        self.lineChartView.chartDescription?.text = ""
        self.lineChartView.gridBackgroundColor = UIColor.clear
        self.lineChartView.xAxis.enabled = false
        self.lineChartView.leftAxis.enabled = false
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.leftAxis.drawLabelsEnabled = false
        self.lineChartView.legend.enabled = false
        self.lineChartView.leftAxis.axisMaximum = 15
        self.lineChartView.rightAxis.axisMaximum = 15
        self.lineChartView.rightAxis.axisMinimum = 5
        self.lineChartView.leftAxis.axisMinimum = 5

        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.setVisibleXRange(minXRange: Double(1), maxXRange: Double(600))
        
//        self.view.sendSubview(toBack: self.lineChartView)
        
        chartTimer = Timer.scheduledTimer(timeInterval: 0.001, target:self, selector: #selector(DeviceViewController.updateCounter), userInfo: nil, repeats: true)

    }
    
    
    // add point
    var i = 0
    var value = Double(5)
    @objc func updateCounter() {
        
        value = (Double(self.gaugeVoltage.rate)*10)+5
//        value = Double(arc4random_uniform(15))
        self.lineChartView.data?.addEntry(ChartDataEntry(x: Double(i), y: value), dataSetIndex: 0)
        
        self.lineChartView.setVisibleXRange(minXRange: Double(1), maxXRange: Double(600))
        self.lineChartView.data?.notifyDataChanged()
        self.lineChartView.notifyDataSetChanged()
        self.lineChartView.moveViewToX(Double(i))
        i = i + 1
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        gaugeBGView.layer.cornerRadius = gaugeBGView.frame.width * 0.5
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated);
        
        self.clearNavigationBar()
        self.tabBarController?.tabBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        
        if(self.centralManager != nil) {//skiped connecting device
            hasDevice = true;
            self.centralManager.delegate = self
            self.centralManager.logLevel = .none
            
            UIApplication.shared.isIdleTimerDisabled = true
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(DeviceViewController.appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
            self.threshold.rate = 1.0;
            self.centralManager.connectDevice(self.device)
            deviceStatus.text = "Connected Devices"
            deviceView.isHidden = false
            //        getVoltage()
            
            //        foregroundNotification = NSNotificationCenter.defaultCenter().addObserverForName(UIApplicationWillEnterForegroundNotification, object: nil, queue: NSOperationQueue.mainQueue()) {
            //            [unowned self] notification in
            //
            //            // do whatever you want when the app is brought back to the foreground
            //        }
        }else{
            hasDevice = false
            deviceStatus.text = "Skipped Connecting a Device."
            deviceView.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true;
        self.playButton.setImage(mainButtonImage, for: UIControlState.normal)
    }
    
    func delay(_ delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    @IBOutlet weak var filterSwitch: UISwitch!
    
    
    //This seems backwards but it works this way
    @IBAction func filterSwitchChange(_ sender: UISwitch) {
        if self.filterSwitch.isOn {
            self.filtering = true
            self.filterSwitch.setOn(true, animated:true)
        } else {
            self.filtering = false
            self.filterSwitch.setOn(false, animated:true)
        }
        
    }
    
    @IBAction func backButtonClicked(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    func getData() {
        let baseFreq: Float = 1000
        let sources: [PXSource] = [PXSource(port: 1, numberOfBits: 16, channelMask: 0x01, frequencyDivisor: 100)]
        
        self.device.startAcquisitionWithBaseFrequency(baseFreq, sourcesArray: sources) { (result, pluxFrame) in
            
            if result {
                
                if let pluxFrame = pluxFrame {
                    var smoothVoltage: Double
//                    print("Start: PluxFrame SEQ: \(pluxFrame.sequence) DATA: \(pluxFrame.analogData)")
                    let pluxResults = pluxFrame.analogData;
                    let pluxResult = Double(pluxResults[0])
                    if (pluxResult < self.minSample && pluxResult > 0.0){
                        self.minSample = pluxResult;
                    }
                    if self.filtering{
                        smoothVoltage = self.smoothVoltage(pluxResult);
                    }else{
                        smoothVoltage = pluxResult // Bypassing Smoothing function
                    }
                    
                    var weighted = self.weight(smoothVoltage)
                    if weighted.isNaN{
                        weighted = 0.0
                    }
                    self.voltage.text = String(format:"%f", weighted);
                    self.gaugeVoltage.rate = CGFloat(weighted * 1.5);
                    if self.monitoring == true && self.threshold.rate < 1.0 {
                        if (self.gaugeVoltage.rate >= CGFloat(self.threshold.rate)){
                            self.playSound("ding")
                        }
                    }
                } else {
                    print("Start: PluxFrame unavailable!")
                }
                
            } else {
                
                print("Start: error!")
            }
        }
        
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        
        if (self.recording){
            self.audioPlayer.pause()
            self.timer!.invalidate();
        }
        self.streaming = false;
        self.recording = false;
        //        self.periodicPinValue.stopNotificationsAsync();
        //        self.underThreshold.stopNotificationsAsync();
        //        self.overThreshold.stopNotificationsAsync();
        //        device.removeObserver(self, forKeyPath: "state")
        self.centralManager.disconnectDevice(self.device)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (self.recording){
            self.audioPlayer.pause();
            self.timer!.invalidate();
        }
        self.streaming = false;
        self.recording = false;
        
        
        //        self.periodicPinValue.stopNotificationsAsync();
        //        self.underThreshold.stopNotificationsAsync();
        //        self.overThreshold.stopNotificationsAsync();
        
        if(self.centralManager != nil){
            self.centralManager.disconnectDevice(self.device)
        }
        //        print("Here's the data")
        //        print(dataLog)
        
        
    }
    
    
    @IBAction func threshold(_ sender: UISlider) {
        self.threshold.rate = CGFloat(sender.value);
        // print(threshold);
    }
    
    // number of data points to smooth at once
    var voltageSize = 10
    var voltageArray = [Double](repeating: 0, count: 10)
    // percent to include of upward data jumps.  Set low to remove anything caused by eye movement
    var includeJumps = 0.5
    
    
    func smoothVoltage(_ vin: Double) -> Double{
        var smooth: Double = 0
        // append roughVoltage to smoothvoltage
        voltageArray.append(vin)
        // remove first of smoothvoltage
        voltageArray.remove(at: 0)
        // sort
        var tempArray = voltageArray
        tempArray.sort(by: <)
        // remove remove amount from high end, save as new array, sum the remaining
        let smoothe = tempArray[0..<Int(3)]
        smooth = smoothe.reduce(0, +)/Double(smoothe.count)
        // average remaining values
        if (smooth.isNaN){
            smooth = 0
        }
        return smooth
    }
    
    func getVoltage() {
        let baseFreq:Float = 1000
        let sources:[PXSource] = [PXSource(port: 1, numberOfBits: 16, channelMask: 0x01, frequencyDivisor: 100)]
        self.device.startAcquisitionWithBaseFrequency(baseFreq, sourcesArray: sources){(result, pluxFrame) in
            if result{
                if let pluxFrame = pluxFrame{
                    print ( "StartCommandResult:\(result)PluxFrame:\(pluxFrame)" )
                    if(self.streaming == true) {
                        self.getVoltage();
                    }
                }
            }else{
                print("StartCommandError!")
            }
        }
    }
    
    
    
    
    
    
    func playSound(_ soundName: String)
    {
        let mySound: SystemSoundID = 1052
        //            AudioServicesCreateSystemSoundID(soundURL, &mySound)
        // Play
        AudioServicesPlaySystemSound(mySound);
        //        }
    }
    
    
    
    
    
    func weight(_ vin: Double) -> Double{
        
        let newv = ((vin - self.minSample) / (0.95 - self.minSample))
        //        let maxv = 1.0;
        //        let maxv = 26624.0
        if (newv > self.maxSample){
            self.maxSample = newv
        }
        let vout = pow((newv / maxSample),(1/2));
        
        return vout;
    }
    
    
    
    
    @IBAction func email(_ sender: UIButton) {
        self.recording = false
        self.timer?.invalidate()
        let filename = "testfile"
        let string = dataLog.description
        
        if(MFMailComposeViewController.canSendMail()){
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            mailComposer.setToRecipients(["palmvalley06@gmail.com"])
            mailComposer.setSubject("Data")
            mailComposer.setMessageBody("Attached", isHTML: false)
            
            //            let joinedString = dataLog.joinWithSeparator(",")
            //            print(joinedString)
            
            if let data = (string as NSString).data(using: String.Encoding.utf8.rawValue){
                //Attach File
                mailComposer.addAttachmentData(data, mimeType: "text/plain", fileName: "Muscle Data")
                self.present(mailComposer, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc func logData(){
        dataLog.append(Double(self.gaugeVoltage.rate))
    }
    
//    @objc func logHeartRateData(){
//        HealthKitManager.sharedInstance.fetchHeartRate(complete: { (heartRate) in
//            self.heartRateLog.append(heartRate)
//            DispatchQueue.main.async {
//                self.heartRateLabel.text = String(format:"Heart Rate: %.f", heartRate)
//            }
//        }) { (error) in
//            NSLog("failed Heart Rate: %@", error?.localizedDescription ?? "");
//            DispatchQueue.main.async {
//                self.heartRateLabel.text = "Failed to fetch HR"
//            }
//        }
//    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func stream(_ sender: UIButton) {
        if (recording == false){
            startTime = NSDate()
            self.mindStartDate = Date()
            sender.setImage(#imageLiteral(resourceName: "stop"), for: UIControlState.normal)
            let lesson = LessonManager.sharedInstance.currentLesson
            if(monitoring){
                startModule(nil);

                if #available(iOS 10.0, *) {
                    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer:Timer) in
                        self.timeNum += 1

                        let hours = Int(self.timeNum) / 60 / 60 % 60
                        let minutes = Int(self.timeNum) / 60 % 60
                        let seconds = Int(self.timeNum) % 60
                        self.timerLabel.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
                    })
                } else {
                    // Fallback on earlier versions
                }
            }else{
                startModule(NSURL(string: lesson!.streamingURL) as! URL);
            }
        } else {
            if(LessonManager.sharedInstance.currentLesson == nil){
                endSession()
                return;
            }

            Helper.showSimpleYesNoError(vc: self, title: "Alert", message: "Are you sure you want to stop your session? You will have to start over if you do.", callBack: { (yes: Bool) in
                if(yes){
                    self.endSession()
                }

            })

        }
    }
    
    func endSession() -> Void {
        playButton.setImage(self.mainButtonImage, for: UIControlState.normal)
        if(!self.monitoring){
            self.audioPlayer.pause();
        }else{
            if #available(iOS 10.0, *) {
                self.timer.invalidate()
            } else {
                // Fallback on earlier versions
            }
        }
        self.recording = false;
        playButton.setTitle("Start Xen", for: UIControlState())
        self.uploadSessionData(showSurvey: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false;
        NotificationCenter.default.removeObserver(self)
    }
    
    func startModule(_ url:URL?){
        
        if(monitoring){
            playModule(nil)
            return;
        }
        
        if(LessonManager.sharedInstance.isLessonDownloaded(lesson: LessonManager.sharedInstance.currentLesson!)){
            
            let name = LessonManager.sharedInstance.currentLesson!.downloadName()
            var documentsURL = LessonManager.sharedInstance.getLessonsPath()
            documentsURL.appendPathComponent(name)
            
            self.playModule(documentsURL)
            
        }else{
            //            Helper.showSimpleYesNoAlert(vc: self, title: "Message", message: "Would you like to download this lesson for offline playback?", callBack: { (yes: Bool) in
            //                if(yes){
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.annularDeterminate
            hud.labelText = "Downloading Lesson..."
            LessonManager.sharedInstance.downloadLesson(lesson: LessonManager.sharedInstance.currentLesson!, callback: { (success:Bool, url:URL) in
                
                hud.hide(animated: true)
                self.playModule(url.standardizedFileURL)
                
                
            }, progressCallback: { (progress:Double) in
                hud.progress = Float(progress)
            })
            //                }else{
            //                    self.playModule(URL(string:LessonManager.sharedInstance.currentLesson!.streamingURL))
            ////                    self.playButton.setImage(self.mainButtonImage, for: UIControlState.normal)
            //                }
            //            })
        }
        
    }
    
    func playModule(_ url:URL?){
        
        do
        {
            if(!monitoring){
                MBProgressHUD.showAdded(to: self.view, animated: true)
                let urlAsset = AVURLAsset(url: url!)
                let duration = CMTimeGetSeconds(urlAsset.duration)
                
                let playerItem = AVPlayerItem(asset: urlAsset)
                
                NotificationCenter.default.addObserver(self, selector: #selector(DeviceViewController.playerDidFinishPlaying(note:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
                self.audioPlayer.automaticallyWaitsToMinimizeStalling = false;
                self.audioPlayer = AVPlayer(playerItem:playerItem)
                self.audioPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC)), queue: nil, using: { (ctime:CMTime) in
                    
                    let time = CMTimeGetSeconds(playerItem.currentTime())
                    if(time > 1){
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                    let timeLeft = duration-time
                    let minutes = Int(timeLeft) / 60 % 60
                    let seconds = Int(timeLeft) % 60
                    self.timerLabel.text = String(format:"%02i:%02i", minutes, seconds)
                    
                })
                
                audioPlayer.volume = 1.0
                
                do {
                    //play when on silent
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                }
                catch {
                    // report for an error
                }
                
                audioPlayer.play()
            }
            self.dataLog = [];
            self.heartRateLog = [];
            recording = true;
            
            buttonText.setTitle("Stop Session", for: UIControlState())
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(DeviceViewController.logData), userInfo: nil, repeats: true)
//            self.healthtimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(DeviceViewController.logHeartRateData), userInfo: nil, repeats: true)
            
        }
        catch let error as NSError {
            print(error.description)
        }
        
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        LessonManager.sharedInstance.currentLesson?.setLessonCompleted(completed: true)
        recording = false
        uploadSessionData()
    }
    
    
    
    func didConnectDevice() {
        deviceStatus.text = "Connected";
        self.streaming = true
    }
    
    func didDisconnectDevice() {
        deviceStatus.text = "Not Connected";
        self.streaming = false
    }
    func didFailToConnectDevice(){
        print("failed to connect")
        self.centralManager.connectDevice(self.device)
    }
    
    func deviceReady() {
        //at this stage, the device is ready to communicate
        self.getDeviceVersion()
    }
    
    func getDeviceVersion(){
        self.device.getVersionOfDeviceWithCompletionBlock{ (result, pluxDevice) in
            if result {
                if let pluxDevice = pluxDevice {
                    self.getData()
                }
                else{
                    print("Version: PluxDevice unavailable")
                }
            }
            else{
                print("Version: error")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "showGraph") {
            let svc = segue.destination as! ChartsViewController;
            svc.data = self.dataLog
        }
    }
    
    //MARK: Data Handler
    func showHRData(callback:@escaping () -> Void){
        if(!DatalogUtil.notEnoughData(self.heartRateLog)) {
            let hrDecrease = DatalogUtil.getHRDecrease(self.heartRateLog)
            Helper.showSimpleError(vc: self, title: (hrDecrease > 0 ? "Congratulations!" : "Oops!"), message: (hrDecrease > 0 ? ("Your Heart Rate reduced by " + String(format:"%.01f", hrDecrease)):("Your Heart Rate increased by" + String(format:"%.01f", hrDecrease) + "Please try again.")), callback: callback)
        } else {
            callback()
            return
        }
    }

    
    func showScoreWithData(data: [Double], callback:@escaping () -> Void){


        if(self.device == nil && self.centralManager == nil){
            callback()
            return
        }
        
        let fifth = Int(data.count/5);
        if(fifth == 0){
            callback()
            return;
        }
        
        let firstPart = data.prefix(through: fifth);
        let lastPart = data.suffix(fifth+1);
        
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
        
        percentage = 100.0 - (increase ? (100) : ((lastAvg/firstAvg)*100.0))
        
        
        
        let percString = String(format:"%.01f", percentage)
        let nan = percentage.isNaN || increase
        Helper.showSimpleError(vc: self, title: (!nan ? "Congratulations!" : "Oops!"), message: (!nan ? ("Your muscle activity reduced by "+percString+"%"):("Your muscle activity did not decrease significantly during the session. Please try again.")), callback: callback)

//        if nan == false{
////            Helper.showSimpleError(vc: self, title: (!nan ? "Congratulations!" : "Oops!"), message: (!nan ? ("Your muscle activity reduced by "+percString+"%"):("Your muscle activity did not decrease significantly during the session. Please try again.")), callback: callback)\//        }else{
//            self.goRootViewController()
//        }
    }
    
    func uploadSessionData() -> Void{
        uploadSessionData(showSurvey: true)
    }
    
    func uploadSessionData(showSurvey:Bool) -> Void{
        
        let data = [Double](self.dataLog)
//        showHRData {
            self.showScoreWithData(data: data) {
                
                let time = NSDate().timeIntervalSince(self.startTime as Date);
                self.mindEndDate = Date()
                HealthKitManager.sharedInstance.saveMindfullAnalysis(startTime: self.mindStartDate, endTime: self.mindEndDate)
                
                let session = Session(aTime: String(time), aData: data, hData: self.heartRateLog, lesson: LessonManager.sharedInstance.currentLesson, aReduction: self.percentage)
                
                MBProgressHUD.showAdded(to: self.view, animated: true)
                SessionManager.sharedInstance.createSession(session: session, success: { (sessionId:String) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.surveySessionId = sessionId;
                    if(showSurvey){
                        self.checkForPostLessonSurvey()
                    }else{
                        LessonManager.sharedInstance.currentLesson = nil
                        self.navigationController?.tabBarController?.selectedIndex = 2
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }) { (error: Error?) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    Helper.showSimpleError(vc: self, title: "Error", message: "Error Saving Session.")
                }
            }
//        }
    }
    
    func checkForPostLessonSurvey(){
        let l = LessonManager.sharedInstance.currentLesson
        if(l != nil){
            //            if(l!.ordinal == LessonManager.sharedInstance.lessons.count){
            //                self.prefix = "(AFTER)"
            //                self.longSurvey()
            //            }else{
            self.shortSurvey()
            //            }
        }else{
            self.navigationController?.tabBarController?.selectedIndex = 3
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    //MARK: Survey Stuff
    var prefix = "(BEFORE)"
    func checkForSurveyNeed(){
        if(UserManager.sharedInstance.currentUser.showLongSurvey == false){
            return;
        }
        if(LessonManager.sharedInstance.currentLesson == nil){
            return
        }
        if (LessonManager.sharedInstance.currentLesson!.ordinal == 1){
            Helper.showSimpleYesNoError(vc: self, title: "Message", message: "Would you like to take a quick survey?", callBack: { (yes:Bool) in
                if(yes){
                    self.prefix = "(BEFORE)"
                    self.longSurvey()
                }
            })
        }
        
    }
    
    func longSurvey(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        SurveyManager.sharedInstance.getLongSurvey(success: { (ss: Survey) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.longSurveyType = true
            self.createAndPresentSurvey(ss: ss)
        }) { (er:Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Helper.showSimpleError(vc: self, title: "Error", message: "Error Retrieving Survey.")
        }
    }
    
    
    private var surveySessionId = "0"
    private var surveyId = "0"
    private var longSurveyType = true
    func shortSurvey(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        SurveyManager.sharedInstance.getShortSurvey(success: { (ss: Survey) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.longSurveyType = false
            self.createAndPresentSurvey(ss: ss)
        }) { (er:Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Helper.showSimpleError(vc: self, title: "Error", message: "Error Retrieving Survey.")
        }
    }
    
    func createAndPresentSurvey(ss: Survey){
        
        self.surveyId = ss.surveyId
        var steps = [ORKStep]()
        
        for q in ss.surveyQuestions {
            var choices = [ORKTextChoice]()
            for answer in q.answers{
                let choice = answer.answer
                let c = ORKTextChoice(text: choice, detailText: nil, value: answer.answerId+"|"+choice as NSCoding & NSCopying & NSObjectProtocol, exclusive: false)
                choices.append(c)
            }
            let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: choices)
            let myStep = ORKQuestionStep(identifier: q.question, title: q.question, answer: questAnswerFormat)
            myStep.title = q.question;
            steps.append(myStep)
            
        }
        
        let task = ORKOrderedTask(identifier: "task", steps: steps)
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        self.present(taskViewController, animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, stepViewControllerWillAppear stepViewController: ORKStepViewController) {
        stepViewController.cancelButtonItem = nil
        stepViewController.skipButtonTitle = "";
    }
    func taskViewController(_ taskViewController: ORKTaskViewController,
                            didFinishWith reason: ORKTaskViewControllerFinishReason,
                            error: Error?) {
        if(reason == ORKTaskViewControllerFinishReason.discarded || reason == ORKTaskViewControllerFinishReason.failed || reason == ORKTaskViewControllerFinishReason.saved){
            dismiss(animated: true, completion: nil)
            if(!longSurveyType || prefix == "(AFTER)"){
                if LessonManager.sharedInstance.currentLesson?.isFavorite == false{
                    self.showAddFavoriteAlert()
                }else{
                    self.goRootViewController()
                }
            }
            return
        }
        var resultString = ""
        if(longSurveyType){
            resultString = prefix + " "
        }
        var resultArray = [[String:String]]()
        let taskResult = taskViewController.result
        if let results = taskResult.results {
            for result in results{
                let res = result as! ORKCollectionResult
                if(res.results != nil){
                    let subRes = res.results![0] as! ORKQuestionResult
                    if(subRes.answer == nil){
                        return
                    }
                    let answer = (subRes.answer as! NSArray).mutableCopy() as! NSMutableArray
                    let ident = (answer[0] as! String).components(separatedBy: "|")[0]
                    let a = (answer[0] as! String).components(separatedBy: "|")[1]
                    resultArray.append(["survey_answer_id":ident])
                    
                    resultString = resultString + subRes.identifier + ": " + a + " | \n\r"
                }
            }
        }
        
        SurveyManager.sharedInstance.uploadSurveyResponses(responsesString:resultString, responses: resultArray, sessionId: surveySessionId, surveyId: surveyId, success: {
            if(!self.longSurveyType || self.prefix == "(AFTER)"){
                if LessonManager.sharedInstance.currentLesson?.isFavorite == false{
                    self.showAddFavoriteAlert()
                }else{
                    self.goRootViewController()
                }
            }else{
                Helper.showSimpleError(vc: self, title: "Message", message: "Thanks for taking our survey!")
            }
        }) { (er:Error?) in
            Helper.showSimpleError(vc: self, title: "Error", message: "Error saving survey data")
        }
        // You could do something with the result here.
        
        // Then, dismiss the task view controller.
        dismiss(animated: true, completion: nil)
    }
    
    func showAddFavoriteAlert(){
        if(LessonManager.sharedInstance.currentLesson != nil){
            let alert = UIAlertController(title: "", message: "Do you want to add this lesson as favorite?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
                MBProgressHUD.showAdded(to: self.view, animated: true)
                LessonManager.sharedInstance.createFavorite(lesson: LessonManager.sharedInstance.currentLesson!, success: { (sessionId:String) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.goRootViewController()
                }) { (error: Error?) in
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.goRootViewController()
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func goRootViewController(){
        LessonManager.sharedInstance.currentLesson = nil
        self.navigationController?.tabBarController?.selectedIndex = 4
        self.navigationController?.popToRootViewController(animated: true)
    }
}



