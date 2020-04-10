//
//  PXHomepageViewController.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 02/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import UIKit
import PluxAPI
import CoreBluetooth

class DevicePairingViewController: BaseViewController, PXBioPluxManagerDelegate {
    
    // MARK:- Properties
    let reuseIdentifier = "DeviceCollectionViewCell"

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scanningView: UIView!
    @IBOutlet weak var skipButtonView: UIView!
    @IBOutlet weak var monitorView: UIView!
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!

//    @IBOutlet weak var onlyWorksMessage: UILabel!
    
    var centralManager = PXBioPluxManager()
    var devicesArray: [PXDevice]!

    @IBOutlet weak var deviceCollectionView: UICollectionView!
    
    // MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager.logLevel = .simple
        self.activityIndi.transform = CGAffineTransform(scaleX: 2.5, y: 2.5)

        initCentralManager()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(LessonManager.sharedInstance.currentLesson == nil){
            self.title = "Monitor"
            monitorView.isHidden = false
            skipButtonView.isHidden = true
        }else{
            self.title = "Training"
            monitorView.isHidden = true
            skipButtonView.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        delay(0.1){
            self.scanDevices()
        }
    }
    
    func scanDevices(){
        self.showScanningView()
        self.centralManager.scanDevices()
    }
    
    func stopScanDevices(){
        self.hideScanningView()
        self.centralManager.stopScanDevices()
    }
    
    func initCentralManager(){
        self.devicesArray = []
        self.centralManager.delegate = self
        self.deviceCollectionView.reloadData()
    }
    
    func delay(_ delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    func configureView() {
        self.scanButton.setTitle("Scan for new Devices", for: UIControlState())
    }
    
    @IBAction func actionScanButton(_ sender: UIButton) {
        scanDevices()
    }
    
    @IBAction func actionBuyMuscleButton(_ sender: UIButton) {
        guard let url = URL(string: "http://resilityhealth.com/shop/") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func didDiscoverNewDevice(_ device: PXDevice) {
        device.deviceName = Utils.getSensorName(device.deviceName)
        self.devicesArray.append(device)
        self.deviceCollectionView.reloadData()
    }
    
    func didConnectDevice() {
        hideScanningView()
    }
    
    func didFailToConnectDevice(){
        hideScanningView()
    }
    
    func didBluetoothPoweredOff(){
        hideScanningView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "GetStarted") {
            let svc = segue.destination as! DeviceViewController;
            svc.device = sender as! PXDevice
            svc.centralManager = self.centralManager
        }
    }
    
    func showScanningView(){
        scanningView.isHidden = false
        scanButton.isHidden = true
    }
    
    func hideScanningView(){
        scanningView.isHidden = true
        deviceCollectionView.isHidden = false
        scanButton.isHidden = false
    }
}

extension DevicePairingViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return devicesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DeviceCollectionViewCell
        let device = devicesArray[indexPath.row]
        cell.setDevice(device)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let device: PXDevice = self.devicesArray[indexPath.row]
        self.centralManager.stopScanDevices()
        performSegue(withIdentifier: "GetStarted", sender: device)
    }
}

