//
//  FavoriteCheckTableViewCell.swift
//  XenPlux
//
//  Created by rockstar on 9/25/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

class FavoriteCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var checkImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabels(_ lesson: Lesson){
        nameLabel.text = lesson.name
        if lesson.isFavorite{
            checkImageView.isHidden = false
        }else{
            checkImageView.isHidden = true
        }
    }

}
