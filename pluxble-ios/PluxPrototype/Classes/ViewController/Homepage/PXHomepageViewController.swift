//
//  PXHomepageViewController.swift
//  PluxAPI
//
//  Created by Marcelo Rodrigues on 02/06/16.
//  Copyright © 2016 Plux. All rights reserved.
//

import UIKit
import PluxAPI

class PXHomepageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PXBioPluxManagerDelegate {

    // MARK:- Properties

    private let primaryColor = UIColor(red: 86/255, green: 98/255, blue: 112/255, alpha: 1)
    private let secondaryColor = UIColor(red: 224/255, green: 227/255, blue: 218/255, alpha: 1)
    private let heightForTableViewCell: CGFloat = 50
    private let heightForTableViewHeader: CGFloat = 40
    
    @IBOutlet private weak var scanButton: UIButton!
    @IBOutlet private weak var devicesTableView: UITableView!
    
    private var centralManager: PXBioPluxManager
    private var devicesArray: [PXDevice]
    
    // MARK:- Lifecycle
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        
        centralManager = PXBioPluxManager()
        devicesArray = [PXDevice]()
        
        super.init(nibName: String(PXHomepageViewController), bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.centralManager.logLevel = .Simple
        
        self.configureNavigationBar()
        self.configureView()
        self.configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.centralManager.delegate = self
        self.devicesArray = []
        self.devicesTableView.reloadData()
    }
        
    // MARK:- Private
    
    private func configureNavigationBar() {
    
        self.title = "Devices"
        self.edgesForExtendedLayout = .None
        self.navigationController?.navigationBar.translucent = false
        self.navigationController!.navigationBar.barTintColor = secondaryColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: primaryColor]
    }
    
    private func configureTableView() {

        self.devicesTableView.delegate = self
        self.devicesTableView.dataSource = self
        self.devicesTableView.tableFooterView = UIView(frame: CGRectZero)
        self.devicesTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.devicesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
    }
    
    private func configureView() {
        
        self.view.backgroundColor = UIColor.clearColor()
        self.scanButton.setTitle("Scan for new Devices", forState: .Normal)
        self.scanButton.backgroundColor = secondaryColor
        self.scanButton.setTitleColor(primaryColor, forState: .Normal)
    }
    
    // MARK:- Actions
    
    @IBAction func actionScanButton(sender: UIButton) {
        
        self.centralManager.scanDevices()
    }
    
    // MARK:- UITableViewDelegate/UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Dequeue Table View Cell
        
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("TableViewCell", forIndexPath: indexPath)
        
        // Configure Table View Cell
    
        let device: PXDevice = self.devicesArray[indexPath.row]
        tableViewCell.textLabel?.text = device.deviceName
        
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let device: PXDevice = self.devicesArray[indexPath.row]
        
        let deviceViewController: PXDeviceViewController = PXDeviceViewController(device: device, centralManager: self.centralManager)
        
        self.centralManager.stopScanDevices()
        self.navigationController?.pushViewController(deviceViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "Total count \(self.devicesArray.count)"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return heightForTableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.devicesArray.count
    }
    
    // MARK:- PXBiopluxDelegate
    
    func didDiscoverNewDevice(device: PXDevice) {
        
        self.devicesArray.append(device)
        self.devicesTableView.reloadData()
    }
}
