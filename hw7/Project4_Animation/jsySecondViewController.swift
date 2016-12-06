//
//  jsySecondViewController.swift
//  HW7
//
//  Created by Jiasheng Yang on 9/25/16.
//  Copyright © 2016 Jiasheng Yang. All rights reserved.


import UIKit

protocol jsySecondViewControllerDelegate : class {
    //func acceptData(data:AnyObject!)
}

class jsySecondViewController: UIViewController {
    weak var delegate : jsySecondViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
 
    @IBAction func diminishView(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
        super.viewDidAppear(animated)
        
        let duration = 2.0
        let delay = 0.0
        let options = UIViewKeyframeAnimationOptions.calculationModePaced
        let fullRotation = CGFloat(M_PI * 2)
        
        
        // rotate imageView
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: options, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: 1/3 * fullRotation)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: 2/3 * fullRotation)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0, animations: {
                self.imageView.transform = CGAffineTransform(rotationAngle: 3/3 * fullRotation)
            })
            
        }, completion: nil)
        
        
        // create path for imageView
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20,y: 150))
        path.addCurve(to: CGPoint(x: 300, y: 140), controlPoint1: CGPoint(x: 140, y: 320), controlPoint2: CGPoint(x: 180, y: 110))
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        // create animation for imageView
        anim.path = path.cgPath
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 3.0
        imageView.layer.add(anim, forKey: "animate position along path")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("svc viewWillDisappear")
        super.viewWillDisappear(animated)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        print("svc view will transition to size")
        super.viewWillTransition(to: size, with: coordinator)
        print("new size coming: \(size)")
    }
}
