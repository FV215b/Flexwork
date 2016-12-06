//
//  DrawTennis.swift
//  jz173-ece590-hw3
//
//  Created by Jianyu Zhang on 9/26/16.
//  Copyright © 2016 Jianyu Zhang. All rights reserved.
//

import UIKit

class DrawTennis: UIView {
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(10.0)
        context?.setStrokeColor(UIColor.orange.cgColor)
        let rectangle = CGRect(x: 5,y: 5,width: 10,height: 10)
        context?.setFillColor(UIColor.orange.cgColor)
        context?.addEllipse(in: rectangle)
        //CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        context?.strokePath()
    }
}
