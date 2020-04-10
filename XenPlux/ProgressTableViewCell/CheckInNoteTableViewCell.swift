//
//  CheckInNoteTableViewCell.swift
//  XenPlux
//
//  Created by rockstar on 8/23/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

protocol CheckInNoteTableViewCellDelegate: class{
    func didTappedViewAllButton(_ checkinSection:Int,_ checkinIndex:Int)
}

class CheckInNoteTableViewCell: UITableViewCell {
    
    
    weak var delegate:CheckInNoteTableViewCellDelegate?

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var viewAllButtonView: UIView!

    @IBOutlet weak var labelHeight: NSLayoutConstraint!

    var checkinSection: Int = 0
    var checkinIndex: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    func setLabel(_ checkin:Checkins){
//        self.noteLabel.text = checkin.note
//        self.timeLabel.text = checkin.createdDate.toTimeString()
//        let height = checkin.note.height(withConstrainedWidth: self.frame.width - 112, font: UIFont.systemFont(ofSize: 15))
//
//        if height > 20{
//            viewAllButtonView.isHidden = false
//        }else{
//            viewAllButtonView.isHidden = true
//        }
//
//        if checkin.isAllView == true {
//            labelHeight.constant = checkin.note.height(withConstrainedWidth: self.frame.width - 112, font: UIFont.systemFont(ofSize: 15))
//        }else{
//            labelHeight.constant = 18
//        }
//    }
    
    func setLabel(_ activity:Activity){
        self.noteLabel.text = activity.checkinNote
        self.timeLabel.text = activity.dateCreated.toTimeString()
        let height = activity.checkinNote.height(withConstrainedWidth: self.frame.width - 112, font: UIFont.systemFont(ofSize: 15))
        
        if height > 20{
            viewAllButtonView.isHidden = false
        }else{
            viewAllButtonView.isHidden = true
        }
        
        if activity.isAllView == true {
            labelHeight.constant = activity.checkinNote.height(withConstrainedWidth: self.frame.width - 112, font: UIFont.systemFont(ofSize: 15))
        }else{
            labelHeight.constant = 18
        }
    }

    
    @IBAction func viewAllButtonClicked() {
        if self.delegate != nil{
            self.delegate?.didTappedViewAllButton(checkinSection,checkinIndex)
        }
    }
}
