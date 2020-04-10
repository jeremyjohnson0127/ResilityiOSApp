//
//  CreateAccViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 2/4/17.
//  Copyright © 2017 MbientLab Inc. All rights reserved.
//

import UIKit
import MBProgressHUD
import FontAwesome_swift
import SafariServices

class CreateAccViewController: UIViewController {
    
    let passwordTextFieldTag = 3
    
    @IBOutlet weak var nameTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var emailTF: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var password: SkyFloatingLabelTextFieldWithIcon!
    
    var isEditingPassword: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initUi(){
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        password.iconFont = UIFont.fontAwesome(ofSize: 15, style: FontAwesomeStyle.regular)
        password.iconText = String.fontAwesomeIcon(name: .lock)
        password.titleLabel!.font = UIFont.systemFont(ofSize: 10);
        emailTF.iconFont = UIFont.fontAwesome(ofSize: 15, style: FontAwesomeStyle.regular)
        emailTF.iconText = String.fontAwesomeIcon(name: .envelope)
        
        nameTF.iconFont = UIFont.fontAwesome(ofSize: 15, style: FontAwesomeStyle.regular)
        nameTF.iconText = String.fontAwesomeIcon(name: .user)
    }
    
    @IBAction func createAccount(_ sender: Any) {
        
        if !isValidEmail(candidate: emailTF.text!){
            emailTF.errorMessage = "Invalid email"
            return
        }

        if(!isValidPassword(candidate: password.text!)){
            Helper.showSimpleError(vc: self, title: "Alert", message: "Invalid password. Please include an uppercase letter, lowercase letter, and a number.")
            return
        }
        
        let alertView = UIAlertController(title: "Message", message: "By creating an account you agree to our terms and conditions", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "I Agree", style: UIAlertActionStyle.destructive, handler: { (action) in
            self.createAccount()
        }))
        alertView.addAction(UIAlertAction(title: "Terms and Conditions", style: UIAlertActionStyle.default, handler: { (action) in
            let svc = SFSafariViewController(url: URL(string:"https://resilityhealth.com/apptandc")!)
            self.present(svc, animated: true, completion: nil)
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alertView, animated: true, completion: nil)
    }
    
    func createAccount() -> Void{
        
        MBProgressHUD.showAdded(to: self.view, animated: true);
        
        UserManager.sharedInstance.createAccount(name: nameTF.text!, userName: emailTF.text!, password: password.text!, success: { (user:User) in
            Helper.showSimpleError(vc: self, title: "Success!", message: "Thanks for creating an account with Xen!", callback:{
            self.dismiss(animated: true, completion: nil)
            })
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error: String?) in
            Helper.showSimpleError(vc: self, title: "Uh Oh!", message: error!, callback:{
                self.dismiss(animated: true, completion: nil)
            })
            MBProgressHUD.hide(for: self.view, animated: true)
        };
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func passwordChanged(_ sender: SkyFloatingLabelTextField) {
        if(isValidPassword(candidate: sender.text!)){
            sender.errorMessage = "";
        }else{
            sender.errorMessage = "Need upper & lowercase with number";
        }
    }
    
    @IBAction func emailChanged(_ sender: SkyFloatingLabelTextField) {
        sender.errorMessage = "";
    }
    
    func isValidPassword(candidate: String) -> Bool {
        let passwordRegex = "(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,15}"
        
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    func isValidEmail(candidate:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: candidate)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0{
                if isEditingPassword == true{
                    self.view.frame.origin.y -= 50
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 50
            }
        }
    }
}

extension CreateAccViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == passwordTextFieldTag{
            isEditingPassword = true
        }else{
            isEditingPassword = false
        }
    }
}
