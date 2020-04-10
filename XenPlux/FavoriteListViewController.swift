//
//  FavoriteListViewController.swift
//  XenPlux
//
//  Created by rockstar on 9/25/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class FavoriteListViewController: UIViewController {

    var lessons = [Lesson]()

    @IBOutlet weak var favoriteCheckTableView: UITableView!

    let favoriteCellReuseIdentifier = "FavoriteCheckTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.favoriteCheckTableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func doneButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FavoriteListViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoriteCheckTableView.dequeueReusableCell(withIdentifier: favoriteCellReuseIdentifier, for: indexPath) as! FavoriteCheckTableViewCell
        let lesson = self.lessons[indexPath.row]
        cell.setLabels(lesson)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let lesson = self.lessons[indexPath.row]
        if !lesson.isFavorite{
            LessonManager.sharedInstance.createFavorite(lesson: lesson, success: { (sessionId:String) in
                lesson.isFavorite = true
                self.favoriteCheckTableView.reloadData()
            }) { (error: Error?) in
                self.showErrorMessage("",(error?.localizedDescription)!);
            }
        }else{
            LessonManager.sharedInstance.deleteFavorite(lesson: lesson, success: { (sessionId:String) in
                lesson.isFavorite = false
                self.favoriteCheckTableView.reloadData()
            }) { (error: Error?) in
                self.showErrorMessage("",(error?.localizedDescription)!);
            }
        }
    }
    
    func showErrorMessage(_ title:String, _ message:String){
        let alert = UIAlertController(title: title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in }))
        self.present(alert, animated: true, completion: nil)
    }

}
