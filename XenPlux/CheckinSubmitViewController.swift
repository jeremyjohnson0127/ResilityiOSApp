//
//  CheckinSubmitViewController.swift
//  XenPlux
//
//  Created by diana on 8/20/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

protocol CheckinSubmitViewControllerDelegate: class{
    func didCheckedIn()
    func didCancelCheckIn()
}

class CheckinSubmitViewController: BaseViewController {
    
    weak var delegate:CheckinSubmitViewControllerDelegate?

    let Slider_Max_Value :Int = 10

    @IBOutlet weak var tenseSlider: UISlider!
    @IBOutlet weak var tiredSlider: UISlider!
    @IBOutlet weak var distractedSlider: UISlider!
    @IBOutlet weak var overwhelmedSlider: UISlider!
    @IBOutlet weak var unhappySlider: UISlider!
    @IBOutlet weak var noteTextView: UITextView!

    var selectedDate: Date?
    
    var checkIn: Checkins = Checkins()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initUi()
    }

    
    func initUi(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func checkInButtonClicked() {
        checkIn.createdDate = selectedDate!
        
        checkIn.tense = Int(tenseSlider.value)
        checkIn.relaxed = Slider_Max_Value - checkIn.tense
        
        checkIn.tired = Int(tiredSlider.value)
        checkIn.rested = Slider_Max_Value - checkIn.tired

        checkIn.distracted = Int(distractedSlider.value)
        checkIn.focused = Slider_Max_Value - checkIn.distracted
        
        checkIn.overwhelmed = Int(overwhelmedSlider.value)
        checkIn.topofthings = Slider_Max_Value - checkIn.overwhelmed
        
        checkIn.unhappy = Int(unhappySlider.value)
        checkIn.content = Slider_Max_Value - checkIn.unhappy

        checkIn.note = noteTextView.text
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        CheckinDataManager.sharedInstance.createCheckIn(checkIn: checkIn, success: { (checkInId:String) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismiss(animated: true, completion: nil)
            if self.delegate != nil{
                self.delegate?.didCheckedIn()
            }
        }) { (error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @IBAction func closeButtonClicked() {
        if self.delegate != nil{
            self.delegate?.didCancelCheckIn()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
