//
//  LoginViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/24/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import FontAwesome_swift

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTF: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.iconFont = UIFont.fontAwesome(ofSize: 15, style: FontAwesomeStyle.regular)
        emailTF.iconText = String.fontAwesomeIcon(name: .envelope)

        passwordTF.iconFont = UIFont.fontAwesome(ofSize: 15, style: FontAwesomeStyle.regular)
        passwordTF.iconText = String.fontAwesomeIcon(name: .lock)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTF.text = UserDefaults.standard.string(forKey: "userName")
        if let token = UserDefaults.standard.string(forKey: "access-token"){
            if(token.characters.count > 0){
                verifyToken()
            }
        }
    }
    
    func verifyToken() -> Void{
        MBProgressHUD.showAdded(to: self.view, animated: true);
        UserManager.sharedInstance.validateToken { (valid: Bool) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if(valid){
                self.performSegue(withIdentifier: "login", sender: self)
            }else{
                Helper.clearToken()
                Helper.showSimpleError(vc: self, title: "Error", message: "Please Login with your email and password again.")
            }
        }
    }
    
    //MARK: Buttons
    @IBAction func loginPressed(_ sender: AnyObject) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserManager.sharedInstance.login(userName: emailTF.text!, password: passwordTF.text!, success: { (user: User) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.saveUserDevice()
        }) { (error: String?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Helper.showSimpleError(vc: self, title: "Error", message: "There was an issue logging in. Verify your username and password then try again.")
        }
    }
    
    @IBAction func resetPassword(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        if let email = emailTF.text {
            UserManager.sharedInstance.resetPassword(userName: email, success: {
                Helper.showSimpleError(vc: self, title: "Message", message: "Successfully reset your password. Please check your email.")
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }) { (error) in
                Helper.showSimpleError(vc: self, title: "Message", message: "Successfully reset your password. Please check your email.")
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }else{
            Helper.showSimpleError(vc: self, title: "Uh Oh", message: "Please enter a valid email")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func saveUserDevice(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UserManager.sharedInstance.saveUserDevice(success: { (deviceType:String) in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.performSegue(withIdentifier: "login", sender: self)
        }) { (error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            Helper.showSimpleError(vc: self, title: "Message", message: "Failed to save device Type.")
            self.performSegue(withIdentifier: "login", sender: self)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}
