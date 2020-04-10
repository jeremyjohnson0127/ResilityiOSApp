//
//  LessonCollectionViewCell.swift
//  XenPlux
//
//  Created by diana on 8/2/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class LessonCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var highLightView: UIView!

    @IBOutlet weak var bgView: RoundShadowView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var clockLabel: UILabel!
    
    @IBOutlet weak var completedView: UIView!
    @IBOutlet weak var doneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setLesson(_ lesson:Lesson,_ index:Int){
        if index%3 == 0{
            if bgView.shadowLayer != nil{
                bgView.shadowLayer.fillColor = UIColor.lesson1Color.cgColor
            }else{
                bgView.fillColor = UIColor.lesson1Color
                bgView.addShadowLayer()
            }
        }else if index%3 == 1{
            if bgView.shadowLayer != nil{
                bgView.shadowLayer.fillColor = UIColor.lesson2Color.cgColor
            }else{
                bgView.fillColor = UIColor.lesson2Color
                bgView.addShadowLayer()
            }
        }else if index%3 == 2{
            if bgView.shadowLayer != nil{
                bgView.shadowLayer.fillColor = UIColor.lesson3Color.cgColor
            }else{
                bgView.fillColor = UIColor.lesson3Color
                bgView.addShadowLayer()
            }
        }
        
        let nameArr = lesson.name.components(separatedBy: "(")
        if nameArr.count>1{
            nameLabel.text = nameArr[0]
            let clockArray = nameArr[1].components(separatedBy: ")")
            if clockArray.count>1{
                clockLabel.text = clockArray[0]
            }else{
                clockLabel.text = nameArr[1]
            }
        }else{
            nameLabel.text = lesson.name
        }
        if lesson.isLessonCompleted(){
            completedView.isHidden = false
        }else{
            completedView.isHidden = true
        }
        doneImageView.isHighlighted = true
        self.highLightView.isHidden = true
    }

    func setLesson(_ lesson:Lesson,_ index:Int,_ isFavorite:Bool){
        setLesson(lesson, index)
        if isFavorite{
            self.highLightView.isHidden = true
        }else{
            self.highLightView.isHidden = false
        }
    }

}
