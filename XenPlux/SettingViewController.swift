//
//  SettingViewController.swift
//  XenPlux
//
//  Created by diana on 8/2/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUi(){
        nameLabel.text = UserManager.sharedInstance.currentUser.name
        emailLabel.text = UserManager.sharedInstance.currentUser.email
    }
    
    @IBAction func signout(_ sender: AnyObject) {
        Helper.showSimpleYesNoError(vc: self, title: "Alert", message: "Are you sure you want to log out, this will clear your credentials.") { (yesClicked:Bool) in
            
            if(yesClicked){
                Helper.clearToken()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
