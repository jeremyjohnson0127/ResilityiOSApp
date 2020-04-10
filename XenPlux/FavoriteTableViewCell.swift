//
//  FavoriteTableViewCell.swift
//  XenPlux
//
//  Created by diana on 8/12/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

protocol FavoriteTableViewCellDelegate: class{
    func didTappedDeleteButton(_ favoriteIndex:Int)
}


class FavoriteTableViewCell: UITableViewCell {
    
    weak var delegate:FavoriteTableViewCellDelegate?

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addingView: UIView!
    @IBOutlet weak var editImageView: UIImageView!

    
    var favoriteIndex: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLabels(_ favorite: Lesson){
        nameLabel.text = favorite.name
        nameLabel.textColor = UIColor.textGrayColor
        addingView.isHidden = false
        editImageView.isHidden = true
    }
    
    func setLabels(_ text: String){
        nameLabel.text = text
        nameLabel.textColor = UIColor.textBlueColor
        addingView.isHidden = true
        editImageView.isHidden = false
    }

    
    @IBAction func didTappedDeleteButton(){
        if self.delegate != nil{
            self.delegate?.didTappedDeleteButton(favoriteIndex)
        }
    }

}
