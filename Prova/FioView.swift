//
//  FioView.swift
//  Prova
//
//  Created by Daniel Bonates on 7/11/15.
//  Copyright (c) 2015 Daniel Bonates. All rights reserved.
//

import UIKit

@IBDesignable class FioView: UIView {

        @IBInspectable var gradientColor1: UIColor = UIColor(red: 0.259, green: 0.588, blue: 0.671, alpha: 1.000)
        @IBInspectable var gradientColor2: UIColor = UIColor(red: 0.075, green: 0.478, blue: 0.584, alpha: 1.000)
    
        @IBInspectable var color1Force: CGFloat = 0.0
        @IBInspectable var color2Force: CGFloat = 1.0
    
    

    override func drawRect(rect: CGRect) {
        

        let context = UIGraphicsGetCurrentContext()
        
        
        
        let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), [gradientColor1.CGColor, gradientColor2.CGColor], [color1Force, color2Force])


        let rectanglePath = UIBezierPath(rect: CGRectMake(0, 0, 2, 138))
        CGContextSaveGState(context)
        rectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0.5, -0), CGPointMake(0.5, 138), 0)
        CGContextRestoreGState(context)
        
    }


}
