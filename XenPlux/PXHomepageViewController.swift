//
//  PXHomepageViewController.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 02/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import UIKit
import PluxAPI

class DevicePairingViewController: UITableViewController, PXBioPluxManagerDelegate {
    
    // MARK:- Properties
    
var items: [String] = ["We", "Heart", "Swift"]
        @IBOutlet weak var scanButton: UIButton!
        @IBOutlet weak var devicesTableView: UITableView!
    
    var centralManager = PXBioPluxManager()
    var devicesArray: [PXDevice]!

    
    // MARK:- Lifecycle
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.centralManager.logLevel = .simple
        
        scanButton.layer.borderColor = UIColor(red:0.38, green:0.69, blue:0.73, alpha:1.00).cgColor
        scanButton.layer.borderWidth = 2
        scanButton.layer.cornerRadius = 10
        if(LessonManager.sharedInstance.currentLesson == nil){
            self.title = "Monitor"
        }else{
            self.title = "Training"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.centralManager.delegate = self
        self.devicesArray = []
        
        self.devicesTableView.reloadData()

        
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        delay(0.1){
            self.centralManager.scanDevices()
        }
    }
    
    func delay(_ delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    

    // MARK:- Private
    
    
    
    func configureView() {
        self.scanButton.setTitle("Scan for new Devices", for: UIControlState())
    }
    
    // MARK:- Actions
    
    @IBAction func actionScanButton(_ sender: UIButton) {

        self.centralManager.scanDevices()
    }
    
    // MARK:- UITableViewDelegate/UITableViewDataSource

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devicesArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell? = self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?
        let device: PXDevice = self.devicesArray[indexPath.row]
        cell!.textLabel?.text = device.deviceName
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        let device: PXDevice = self.devicesArray[indexPath.row]
        self.centralManager.stopScanDevices()
        performSegue(withIdentifier: "GetStarted", sender: device)

    }
    
    // MARK:- PXBiopluxDelegate
    
    func didDiscoverNewDevice(_ device: PXDevice) {
        
        self.devicesArray.append(device)
        self.devicesTableView.reloadData()
    }
    
    func didConnectDevice() {
        print("connected")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "GetStarted") {
            let svc = segue.destination as! DeviceViewController;
            
            svc.device = sender as! PXDevice
            svc.centralManager = self.centralManager
            
        }
    }

}
