//
//  CheckinViewController.swift
//  XenPlux
//
//  Created by diana on 8/20/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import FSCalendar

class CheckinViewController: UIViewController {

    @IBOutlet weak var checkedInView: UIView!
    @IBOutlet weak var checkinButtonView: UIView!

    @IBOutlet weak var calendar: FSCalendar!
    
    var isCancleCheckIn : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        initUi()
        
        if CheckinDataManager.sharedInstance.isTodayCheckedIn() == false &&
            isCancleCheckIn == false{
            self.performSegue(withIdentifier: "Checkin", sender: nil)
        }
        isCancleCheckIn = false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUi(){

        initCalendarStyle()
        
        if CheckinDataManager.sharedInstance.isTodayCheckedIn(){
            checkedInView.isHidden = false
            checkinButtonView.isHidden = true
        }else{
            checkedInView.isHidden = true
            checkinButtonView.isHidden = false
        }
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
    }
    
    func initCalendarStyle(){
        self.calendar.scope = .week
        self.calendar.calendarHeaderView.isHidden = true
        self.calendar.headerHeight = 20
        self.calendar.borderColor = UIColor.clear
        self.calendar.backgroundColor = UIColor.clear
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        let svc = segue.destination as! CheckinSubmitViewController
        if calendar.selectedDate != nil{
            svc.selectedDate = calendar.selectedDate
        }else{
            svc.selectedDate = Date()
        }
        svc.delegate = self
    }
    
    @IBAction func performCheckInButtonClicked() {
        self.navigationController?.tabBarController?.selectedIndex = 2
    }
}

extension CheckinViewController: CheckinSubmitViewControllerDelegate{
    func didCheckedIn(){
        CheckinDataManager.sharedInstance.saveLastCheckInDate()
        initUi()
    }
    
    func didCancelCheckIn(){
        isCancleCheckIn = true;
    }
}
