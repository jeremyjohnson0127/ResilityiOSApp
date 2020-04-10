//
//  HomeViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import SafariServices

class HomeViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var checkInWeekdayLabel: UILabel!
    @IBOutlet weak var checkInTimeLabel: UILabel!

    @IBOutlet weak var trainingSubTitleLabel: UILabel!
    @IBOutlet weak var trainingTimeLabel: UILabel!
    
    @IBOutlet weak var monitorTimeLabel: UILabel!
    @IBOutlet weak var progressTimeLabel: UILabel!

    var allCheckIns = [Checkins]()
    
    var trainingExercises = [Session]()
    var monitoringSessions = [Session]()

    let EMOJI_MORNING = "☀" //"☀"
    let EMOJI_AFTERNOON = "⛅" //"⛅"
    let EMOJI_EVENING = "🌙" //"🌙"
    
    var hud:MBProgressHUD = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        selectGreeting()
        getCheckIns()
//        self.showAlertForHRVar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    func showAlertForHRVar() {
//        HealthKitManager.sharedInstance.fetchHRVariablity(complete: { value in
//            let alert = UIAlertController(title: "", message: "Heart Rate Variability SDNN - " + String(format:"%.1f", value), preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//            }))
//            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }) { error in
//        }
//        
//        HealthKitManager.sharedInstance.fetchRestingHeartRate(complete: { value in
//            var message = ""
//            if (value == 0) {
//                message = "No Resting Heart Rate"
//            } else {
//                message = "Resting Heart Rate - " + String(format:"%.1f", value)
//            }
//            
//            let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
//            }))
//            alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }) { error in
//        }
//    }
    

    
    func selectGreeting() -> Void{
        let now = NSDate()
        let cal = NSCalendar.current as NSCalendar
        let comps = cal.components(.hour, from: now as Date)
        let hour = comps.hour!

        var firstName = ""

        let fullNameArr = UserManager.sharedInstance.currentUser.name.components(separatedBy: " ")
        if fullNameArr.count>0{
            firstName = fullNameArr[0]
        }else{
            firstName = UserManager.sharedInstance.currentUser.name
        }
        
        switch hour {
        case 0 ... 11:
            greetingLabel.text = "Good Morning  "
            nameLabel.text = firstName + EMOJI_MORNING
        case 12 ... 17:
            greetingLabel.text = "Good Afternoon  "
            nameLabel.text = firstName + EMOJI_AFTERNOON
        default:
            greetingLabel.text = "Good Evening  "
            nameLabel.text = firstName + EMOJI_EVENING
        }
    }
    
    @IBAction func checkInToday(_ sender: AnyObject) {
        self.navigationController?.tabBarController?.selectedIndex = 1
    }

    
    @IBAction func startTraining(_ sender: AnyObject) {
        self.navigationController?.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func monitorTension(_ sender: AnyObject) {
        self.navigationController?.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func viewProgress(_ sender: AnyObject) {
        self.navigationController?.tabBarController?.selectedIndex = 4
    }
    
    @IBAction func showFAQ(_ sender: Any) {
        let svc = SFSafariViewController(url: URL(string:"http://resilityhealth.com/app-help")!);
        self.present(svc, animated: true, completion: nil);
    }
    
    func getCheckIns(){
        self.allCheckIns.removeAll()
        self.monitoringSessions.removeAll()
        self.trainingExercises.removeAll()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        CheckinDataManager.sharedInstance.getCheckIns(success: { (s: [Checkins]) in
            self.allCheckIns = s
            self.hud.hide(animated: true)
            self.getSessions()
        }) { (error:Error?) in
            self.hud.hide(animated: true)
        }
    }
    
    func getSessions(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        SessionManager.sharedInstance.getSessions(success: { (s: [Session]) in
            for session in s{
                if session.lessonId == "0"{
                    self.monitoringSessions.append(session)
                    
                }else{
                    self.trainingExercises.append(session)
                }
            }
            self.hud.hide(animated: true)
            self.setLabels()
        }) { (error:Error?) in
            self.hud.hide(animated: true)
        }
    }
    
    func setLabels(){
        let today = Date()
        var lastMonitorDate = Date(timeIntervalSince1970: 0)
        var lastProgressDate = Date(timeIntervalSince1970: 0)

//        let lastProgressDate : Date?
        
        checkInWeekdayLabel.text = today.toWeekday()
        checkInTimeLabel.text = today.toDateString()
        
        if self.monitoringSessions.count > 0{
            for monitor in self.monitoringSessions{
                if lastMonitorDate < monitor.dateCreated{
                    lastMonitorDate = monitor.dateCreated
                    lastProgressDate = monitor.dateCreated
                }
            }
            monitorTimeLabel.text = lastMonitorDate.toDateString()
        }else{
            monitorTimeLabel.text = "Never"
        }
        
        let updatedCount = self.monitoringSessions.count +  self.trainingExercises.count + self.allCheckIns.count
        if updatedCount > 0{
            for monitoSession in self.monitoringSessions{
                if lastProgressDate < monitoSession.dateCreated{
                    lastProgressDate = monitoSession.dateCreated
                }
            }

            for training in self.trainingExercises{
                if lastProgressDate < training.dateCreated{
                    lastProgressDate = training.dateCreated
                }
            }
            
            for checkin in self.allCheckIns{
                if lastProgressDate < checkin.createdDate{
                    lastProgressDate = checkin.createdDate
                }
            }
            progressTimeLabel.text = lastProgressDate.toDateString()
        }else{
            progressTimeLabel.text = "Never"
        }
        
    }

}
