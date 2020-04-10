//
//  DeviceCollectionViewCell.swift
//  XenPlux
//
//  Created by diana on 8/2/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit
import PluxAPI

class DeviceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!

    func setDevice(_ device :PXDevice){
        if device.deviceName == "No Name"{
            nameLabel.text = "Muscle Activity Sensor"
        }else{
            nameLabel.text = device.deviceName
        }
        idLabel.text = device.deviceUUID
    }
}
