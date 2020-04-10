//
//  InstructionViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 10/11/17.
//  Copyright © 2017 MbientLab Inc. All rights reserved.
//

import UIKit

class InstructionViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var lesson:Lesson! = Lesson()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlRequest:URLRequest = URLRequest(url: URL(string: lesson.instructionLink)!)
        webView.scrollView.bounces = false;
        webView.delegate = self;
        webView.loadRequest(urlRequest)
        // Do any additional setup after loading the view.
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (request.url!.scheme! == "inapp") {
            if (request.url!.host! == "gotolesson") {
                dismiss(animated: true, completion: nil)

            }
            return false;
        }
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exit(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
