//
//  CustomCircleView.swift
//  SwiftStarter
//
//  Created by Ty Parker on 2/3/16.
//  Copyright © 2016 MbientLab Inc. All rights reserved.
//

import UIKit

class CustomCircleView: UILabel {
    
    let screenSize: CGRect = UIScreen.main.bounds

    override func draw(_ rect: CGRect) {
        frame = CGRect(
            x: 0.5 * screenSize.width,
            y: 0.5 * screenSize.height,
            width: 0.5 * screenSize.width,
            height: 0.5 * screenSize.height
        );

        let path = UIBezierPath(ovalIn: rect)
        UIColor.green.setFill()
        path.fill()
    }
}
