//
//  LessonViewController.swift
//  XenPlux
//
//  Created by Alan Mikel Gonzalez on 9/24/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit
import MBProgressHUD

class LessonViewController: BaseViewController {

    
    @IBOutlet weak var lessonCollectionView: UICollectionView!
    @IBOutlet weak var favoriteTableView: UITableView!
    @IBOutlet weak var favoriteView: UIView!

    var lessons = [Lesson]()

    var favoritesLessons = [Lesson]()

    let reuseIdentifier = "LessonCollectionViewCell"
    let favoriteCellReuseIdentifier = "FavoriteTableViewCell"
    
    var isAddingFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.favoriteTableView.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: favoriteCellReuseIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isAddingFavorite = false
        reloadData()
        LessonManager.sharedInstance.currentLesson = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func reloadData() -> Void{
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LessonManager.sharedInstance.getLessons(success: { (l: [Lesson]) in
            self.lessons.removeAll()
            self.lessons = l
            self.getFavorite()
            DispatchQueue.main.async {
                self.lessonCollectionView.reloadData()
            }
        }) { (error:Error?) in
            self.getFavorite()
        }
    }
    
    func getFavorite(){
        LessonManager.sharedInstance.getFavorites(success: { (l: [Lesson]) in
            self.favoritesLessons.removeAll()
            self.favoritesLessons = l
            if self.favoritesLessons.count == 0 {
                self.favoriteView.isHidden = true
            }else{
                self.favoriteView.isHidden = false
                DispatchQueue.main.async {
                    self.favoriteTableView.reloadData()
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }) { (error:Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if(segue.identifier == "addFavorite"){
            let svc = segue.destination as! FavoriteListViewController
            var lessons = [Lesson]()
            for lesson in self.lessons{
                lesson.isFavorite = self.isFavorite(lesson)
                lessons.append(lesson)
            }
            svc.lessons = lessons
        }
    }
    
    func isFavorite(_ lesson:Lesson) -> Bool{
        for favoritelesson in self.favoritesLessons{
            if lesson.lessonId == favoritelesson.lessonId{
                return true
            }
        }
        return false
    }
}

extension LessonViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! LessonCollectionViewCell
        let lesson = lessons[indexPath.row]
        if self.isAddingFavorite == false{
            cell.setLesson(lesson,indexPath.row)
        }else{
            let isFavorite = self.isFavorite(lesson)
            cell.setLesson(lesson, indexPath.row,isFavorite)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lesson = lessons[indexPath.row]
        if isAddingFavorite {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            LessonManager.sharedInstance.createFavorite(lesson: lesson, success: { (sessionId:String) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.isAddingFavorite = false
                self.lessonCollectionView.reloadData()                
                self.favoritesLessons.append(lesson)
                self.favoriteTableView.reloadData()
            }) { (error: Error?) in
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }else{
            LessonManager.sharedInstance.currentLesson = lesson
            LessonManager.sharedInstance.currentLesson?.isFavorite = self.isFavorite(lesson)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DevicePairingViewController") as! DevicePairingViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LessonViewController:UITableViewDataSource,UITableViewDelegate,FavoriteTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 44
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesLessons.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.favoriteTableView.dequeueReusableCell(withIdentifier: favoriteCellReuseIdentifier, for: indexPath) as! FavoriteTableViewCell
        if indexPath.row == self.favoritesLessons.count{
            cell.setLabels("Edit Favorite Exercises")
        }else{
            let favorite = self.favoritesLessons[indexPath.row]
            cell.setLabels(favorite)
        }
        cell.favoriteIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == self.favoritesLessons.count{
            self.performSegue(withIdentifier: "addFavorite", sender: nil)
        }else{
            LessonManager.sharedInstance.currentLesson = favoritesLessons[indexPath.row]
            LessonManager.sharedInstance.currentLesson?.isFavorite = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DevicePairingViewController") as! DevicePairingViewController
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTappedDeleteButton(_ favoriteIndex:Int){
        
        let alert = UIAlertController(title: "", message: "Do you want to delete this lesson in favorites?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            let lesson = self.favoritesLessons[favoriteIndex]
            self.deleteFavorite(lesson)
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteFavorite(_ lesson: Lesson){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        LessonManager.sharedInstance.deleteFavorite(lesson: lesson, success: { (sessionId:String) in
            self.getFavorite()
        }) { (error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showLessonListAlertView(){
        
    }
}

