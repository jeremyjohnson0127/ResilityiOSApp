//
//  SessionTableViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/27/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class SessionTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var sessions = [Session]()
    var filteredSessions = [Session]()
    var hud:MBProgressHUD = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hud = MBProgressHUD(view: self.view)
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func reloadData() -> Void{
        segmentControl.selectedSegmentIndex = 0
        hud.hide(animated: true)
        hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        SessionManager.sharedInstance.getSessions(success: { (s: [Session]) in
            self.sessions = s
//            DispatchQueue.main.async {
                self.filterSessions()
                self.tableView.reloadData()
                self.hud.hide(animated: true)
//            }
        }) { (error:Error?) in
            self.hud.hide(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSessions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SessionTableViewCell

        let session = self.filteredSessions[indexPath.row]
        
        cell.setSession(session: session)

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        filterSessions()
        self.tableView.reloadData()
    }
    
    func filterSessions()->Void{
        filteredSessions = [Session]()
        let i = segmentControl.selectedSegmentIndex
        for session in sessions{
            if (i == 0){
                filteredSessions.append(session)
            }else if (i == 1){
                if(session.lessonId != "0"){
                    filteredSessions.append(session)
                }
            }else{
                if(session.lessonId == "0"){
                    filteredSessions.append(session)
                }
            }
        }
    }
}
