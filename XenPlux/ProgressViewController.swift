//
//  ProgressViewController.swift
//  XenPlux
//
//  Created by rockstar on 8/22/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import FSCalendar


class ProgressViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var progressTableView: UITableView!
//    @IBOutlet weak var progress2TableView: UITableView!

    @IBOutlet weak var exerciseCountLabel: UILabel!
    @IBOutlet weak var checkinCountLabel: UILabel!
    @IBOutlet weak var monitorCountLabel: UILabel!
    
    let checkInNoteCellReuseIdentifier = "CheckInNoteTableViewCell"
    let dailyCheckInCellReuseIdentifier = "DailyCheckInTableViewCell"
    let sessionChartCellReuseIdentifier = "SessionChartTableViewCell"

    var hud:MBProgressHUD = MBProgressHUD()

    var allCheckIns = [Checkins]()
    
    var trainingExercises = [Session]()
    var monitoringSessions = [Session]()
    
    var weekFilterCheckIns = [Checkins]()

    var filterCheckIns = [Checkins]()
    var filterTrainingExercises = [Session]()
    var filterMonitoringSessions = [Session]()
    
    var checkInDates = [String]()
    var trainingExerciseDates = [String]()
    var monitoringSessionDates = [String]()
    
    var weekdayStrings = [String]()
    var dailyActionCounts = [Int]()
    
    var allActivities = [Activity]()
    var filterActivities = [Activity]()
    
    var dailyActivities : [[Activity]] = [[],[],[],[],[],[],[]]

    var isFilterByDate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isFilterByDate = false
        getCheckIns()
        initNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUi(){
        initCalendarStyle()
        self.progressTableView.register(UINib(nibName: "DailyCheckInTableViewCell", bundle: nil), forCellReuseIdentifier: dailyCheckInCellReuseIdentifier)
        self.progressTableView.register(UINib(nibName: "CheckInNoteTableViewCell", bundle: nil), forCellReuseIdentifier: checkInNoteCellReuseIdentifier)
        self.progressTableView.register(UINib(nibName: "SessionChartTableViewCell", bundle: nil), forCellReuseIdentifier: sessionChartCellReuseIdentifier)
    }
    
    func initNavigationBar(){
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    func initCalendarStyle(){
        self.calendar.scope = .week
        self.calendar.calendarHeaderView.isHidden = true
        self.calendar.headerHeight = 20
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.allowsSelection = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.appearance.caseOptions = [.headerUsesUpperCase]
    }
    
    func initEventDay(){
    }
    
    func getCheckIns(){
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        CheckinDataManager.sharedInstance.getCheckIns(success: { (s: [Checkins]) in
            self.allCheckIns = s
            self.filterCheckIns = s
            for checkin in self.allCheckIns{
                self.checkInDates.append(checkin.createdDate.toString2())
            }
            self.hud.hide(animated: true)
            self.getSessions()
        }) { (error:Error?) in
            self.hud.hide(animated: true)
        }
    }
    
    func getSessions(){
        
        self.monitoringSessions.removeAll()
        self.filterMonitoringSessions.removeAll()
        self.trainingExercises.removeAll()
        self.filterTrainingExercises.removeAll()
        
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        SessionManager.sharedInstance.getSessions(success: { (s: [Session]) in
            for session in s{
                if session.lessonId == "0"{
                    self.monitoringSessions.append(session)
                    self.filterMonitoringSessions.append(session)
//                    for monitorSession in self.monitoringSessions{
                    self.monitoringSessionDates.append(session.dateCreated.toString2())
//                    }

                }else{
                    self.trainingExercises.append(session)
                    self.filterTrainingExercises.append(session)
                    self.trainingExerciseDates.append(session.dateCreated.toString2())
                }
//                self.checkInDates.append(session.dateCreated.toString2())
            }
            self.getFilterListbyPage(self.calendar.currentPage.startOfWeek ?? self.calendar.currentPage)
            self.reloadView()
            self.hud.hide(animated: true)
        }) { (error:Error?) in
            self.hud.hide(animated: true)
        }
    }
    
    func reloadView(){
        self.initCalendarStyle()
        self.calendar.reloadData()
        self.progressTableView.reloadData()
    }
    
    func filterArrayByDate(_ date:Date) -> Int{
        
        isFilterByDate = false
        
        let localeString  = date.toString2()
        self.filterCheckIns.removeAll()
        self.filterTrainingExercises.removeAll()
        self.filterMonitoringSessions.removeAll()
        self.filterActivities.removeAll()
        
        for checkin in allCheckIns{
            if checkin.createdDate.toString2() == localeString{
                self.filterCheckIns.append(checkin)
                let activity = Activity.init(checkin: checkin)
                self.filterActivities.append(activity)
            }
        }
        
        for mornitorSession in monitoringSessions{
            if mornitorSession.dateCreated.toString2() == localeString{
                self.filterMonitoringSessions.append(mornitorSession)
                let activity = Activity.init(session: mornitorSession, isTraining: false)
                self.filterActivities.append(activity)
            }
        }
        
        for training in trainingExercises{
            if training.dateCreated.toString2() == localeString{
                self.filterTrainingExercises.append(training)
                let activity = Activity.init(session: training, isTraining: true)
                self.filterActivities.append(activity)
            }
        }
        
        return self.filterTrainingExercises.count + self.filterCheckIns.count + self.filterMonitoringSessions.count
    }
    
    func getFilterListbyPage(_ date: Date){
        self.weekdayStrings = date.getWeekDayStrings()
        self.filterCheckIns.removeAll()
        self.filterTrainingExercises.removeAll()
        self.filterMonitoringSessions.removeAll()
        self.weekFilterCheckIns.removeAll()
        self.filterActivities.removeAll()
        isFilterByDate = false
        
        for checkin in allCheckIns{
            if self.weekdayStrings.contains(checkin.createdDate.toString2()){
                self.filterCheckIns.append(checkin)
                self.weekFilterCheckIns.append(checkin)
                let activity = Activity.init(checkin: checkin)
                self.filterActivities.append(activity)
            }
        }
        
        for mornitorSession in monitoringSessions{
            if self.weekdayStrings.contains(mornitorSession.dateCreated.toString2()){
                self.filterMonitoringSessions.append(mornitorSession)
                let activity = Activity.init(session: mornitorSession, isTraining: false)
                self.filterActivities.append(activity)

            }
        }
        
        for training in trainingExercises{
            if self.weekdayStrings.contains(training.dateCreated.toString2()){
                self.filterTrainingExercises.append(training)
                let activity = Activity.init(session: training, isTraining: true)
                self.filterActivities.append(activity)
            }
        }
        
        self.hud.hide(animated: true)
        
        self.exerciseCountLabel.text = String(self.filterTrainingExercises.count)
        self.monitorCountLabel.text = String(self.filterMonitoringSessions.count)
        self.checkinCountLabel.text = String(self.filterCheckIns.count)
        initDailyActivities(date)
        
        self.reloadView()
    }
    
    func initDailyActivities(_ date: Date){
        for index in 0...6{
            self.dailyActivities[index].removeAll()
        }
        for activity in filterActivities{
            if activity.dateCreated.toDateString() == date.toDateString(){
                self.dailyActivities[6].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(1).toDateString(){
                self.dailyActivities[5].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(2).toDateString(){
                self.dailyActivities[4].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(3).toDateString(){
                self.dailyActivities[3].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(4).toDateString(){
                self.dailyActivities[2].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(5).toDateString(){
                self.dailyActivities[1].append(activity)
            }else if activity.dateCreated.toDateString() == date.plusDay(6).toDateString(){
                self.dailyActivities[0].append(activity)
            }
        }
        
        for index in 0...6{
            self.dailyActivities[index] = self.dailyActivities[index].sorted(by: {
                $0.dateCreated.compare($1.dateCreated) == .orderedDescending
            })
        }
    }
}

extension ProgressViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            if isFilterByDate{
                return 0
            }else{
                return 215
            }
        }else if indexPath.section == 1{
            return 0
        }else{
            let activity = self.dailyActivities[indexPath.section-2][indexPath.row]
            if activity.activityType == ActivityType.checkin.rawValue{
                if activity.isAllView == true{
                    let labelWidth = self.view.frame.width - 112
                    return 75  + activity.checkinNote.height(withConstrainedWidth: labelWidth, font: UIFont.systemFont(ofSize: 15))
                }else{
                    return 75
                }
            }else{
                return 182
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if isFilterByDate{
                return 0.0
            }else{
                return UITableViewAutomaticDimension
            }

        }else if section == 1{
            return UITableViewAutomaticDimension
        }else{
            if self.dailyActivities[section-2].count == 0{
                return 0.0
            }else{
                return UITableViewAutomaticDimension
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 + self.weekdayStrings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0{
            return 1
        }else if section == 1{
            return 0
        }else{
            return self.dailyActivities[section-2].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0 {
            let cell = self.progressTableView.dequeueReusableCell(withIdentifier: dailyCheckInCellReuseIdentifier, for: indexPath) as! DailyCheckInTableViewCell
            cell.setCombinedChartView(self.weekFilterCheckIns,self.calendar.currentPage.startOfWeek ?? self.calendar.currentPage)
            return cell
        }else{
            let activity = self.dailyActivities[indexPath.section-2][indexPath.row]
            if activity.activityType == ActivityType.training.rawValue{
                let cell = self.progressTableView.dequeueReusableCell(withIdentifier: sessionChartCellReuseIdentifier, for: indexPath) as! SessionChartTableViewCell
                cell.setSessionView(activity)
                return cell

            }else if activity.activityType == ActivityType.monitoring.rawValue{
                let cell = self.progressTableView.dequeueReusableCell(withIdentifier: sessionChartCellReuseIdentifier, for: indexPath) as! SessionChartTableViewCell
                cell.setSessionView(activity)
                return cell

            }else{
                let cell = self.progressTableView.dequeueReusableCell(withIdentifier: checkInNoteCellReuseIdentifier, for: indexPath) as! CheckInNoteTableViewCell
//                let checkIn = self.filterCheckIns[indexPath.row - self.filterTrainingExercises.count]
                cell.delegate = self
                cell.checkinSection = indexPath.section - 2
                cell.checkinIndex = indexPath.row
                cell.setLabel(activity)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        if section == 0 || section == 1{
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.font = UIFont.systemFont(ofSize: 13)
            header.textLabel?.textColor = UIColor.testGray2Color
            header.backgroundView?.backgroundColor = UIColor.bgColor
            header.textLabel?.textAlignment = .left

        }else{
            let header = view as! UITableViewHeaderFooterView
            header.textLabel?.font = UIFont.systemFont(ofSize: 13)
            header.textLabel?.textColor = UIColor.textDarkGrayColor
            header.backgroundView?.backgroundColor = UIColor.bgColor
            header.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if section == 0{
            return "DAILY CHECK INS"
        }else if section == 1{
            return "DAILY ACTIVITIES"
        }else{
            return self.weekdayStrings[section-2]
        }
    }
    
}

extension ProgressViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return self.allCheckIns.count
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if checkInDates.contains(date.toString2()) ||
            monitoringSessionDates.contains(date.toString2()) ||
            trainingExerciseDates.contains(date.toString2()){
            return UIColor.calendarCheckInColor
        }
        if date.toDateString() == Date().toDateString(){
            return UIColor.calendarSelectionColor
        }
        return UIColor.white
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        return 1
    }
    
    func calendarCurrentPageDidChange(_ calendar : FSCalendar ){
        let currentPage = calendar.currentPage
        if calendar.selectedDate != nil{
            calendar.deselect(calendar.selectedDate!)
        }
        getFilterListbyPage(currentPage)
    }
}

extension ProgressViewController: CheckInNoteTableViewCellDelegate{

    func didTappedViewAllButton(_ checkinSection:Int,_ checkinIndex:Int){
        self.dailyActivities[checkinSection][checkinIndex].isAllView = !self.dailyActivities[checkinSection][checkinIndex].isAllView
        let indexPath = IndexPath.init(row: checkinIndex, section: checkinSection + 2)
        self.progressTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
}
