//
//  XTabBarController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/26/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import Toast_Swift

class XTabBarController: UITabBarController, UITabBarControllerDelegate{

    var vcTapped:UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.makeToast("Welcome to Resility "+UserManager.sharedInstance.currentUser.name, duration: 3.0, position: .bottom)
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        vcTapped = viewController;
        if (self.selectedIndex == 2 && LessonManager.sharedInstance.currentLesson != nil){
            Helper.showSimpleYesNoError(vc: self, title: "Alert", message: "Are you sure you want to leave your session? You will have to start over if you do.", callBack: { (yes: Bool) in
                if(yes){
                    LessonManager.sharedInstance.currentLesson = nil
                    (self.selectedViewController as! UINavigationController).popToRootViewController(animated: false)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
                        self.selectedViewController = self.vcTapped
                    })
                }
                
            })
            return false
        }
        return true
    }
}
