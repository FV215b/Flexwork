//
//  DrawingView.swift
//  Project4_Animation
//
//  Created by Yuchen Zhou on 9/26/16.
//  Copyright © 2015 Duke University. All rights reserved.
//
//  This is the class for drawing in SecondViewController

import UIKit

class drawingView: UIView {
    
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // drawing a graphic using CG
    override func draw(_ rect:  CGRect) {
        let con = UIGraphicsGetCurrentContext()
        con?.addEllipse(in: CGRect(x: 0, y: 0, width: 40, height: 40))
        con?.setFillColor(UIColor(colorLiteralRed: 1, green: 0.843, blue: 0, alpha: 1).cgColor)
        con?.fillPath()
        con?.addEllipse(in: CGRect(x: 2, y: 2, width: 36, height: 36))
        con?.setFillColor(UIColor(colorLiteralRed: 1, green: 0.875, blue: 0, alpha: 1).cgColor)
        con?.fillPath()
        con?.addEllipse(in: CGRect(x: 5, y: 5, width: 30, height: 30))
        con?.setFillColor(UIColor(colorLiteralRed: 1, green: 0.843, blue: 0, alpha: 1).cgColor)
        con?.fillPath()
        con?.addEllipse(in: CGRect(x: 7, y: 7, width: 26, height: 26))
        con?.setFillColor(UIColor(colorLiteralRed: 1, green: 0.875, blue: 0, alpha: 1).cgColor)
        con?.fillPath()
        con?.addRect(CGRect(x: 17, y: 10, width: 6, height: 20))
        con?.setFillColor(UIColor(colorLiteralRed: 205/255, green: 133/255, blue: 63/255, alpha: 0.4).cgColor)
        con?.fillPath()
    }
}
