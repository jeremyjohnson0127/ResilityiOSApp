//
//  RoundShadowView.swift
//  XenPlux
//
//  Created by rockstar on 8/2/18.
//  Copyright © 2018 MbientLab Inc. All rights reserved.
//

import UIKit

@IBDesignable class RoundShadowView: UIView {

    var shadowLayer: CAShapeLayer!
    @IBInspectable var cornerRadius: CGFloat = 16.0
    @IBInspectable var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    @IBInspectable var shadowColor: UIColor!
    override func layoutSubviews() {
        super.layoutSubviews()
        addShadowLayer()
    }
    
    func addShadowLayer(){
        if shadowColor == nil{
            shadowColor = UIColor.shadowColor
        }
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 3
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

}
