//
//  SecondViewController.swift
//  Veggie_Info
//
//  Created by Yuchen Zhou on 9/25/16.
//  Copyright © 2016 Duke University. All rights reserved.
//
//  This view controller draws the animation view that shows up after flipping from detail view

import UIKit

protocol SecondViewControllerDelegate: class {
    func acceptData(_ data: AnyObject!)
}

// This is the controller of Animation
class SecondViewController: UIViewController {
    
    
    @IBOutlet weak var superMario: UIImageView!
    @IBOutlet weak var hobbyLabel: UILabel!
    @IBOutlet weak var dv: drawingView!
    @IBOutlet weak var dvStatic: drawingView!
    @IBOutlet weak var superMarioTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dvTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var dvStaticTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateSlide: UISlider!
    @IBOutlet weak var gameImage: UIImageView!
    
    var rate: Double = 0.4 {
        didSet {
            superMarioTopConstraint.constant += 80
            dvTopConstraint.constant += 400
            dvStaticTopConstraint.constant += 30
            animateImageTransitions()
        }
    }
    
    weak var delegate: SecondViewControllerDelegate?
    
    @IBAction func doDismiss(_ sender: AnyObject?) {
        // var vc = self.delegate! as AnyObject as! UIViewController
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateImageTransitions()
    }
    
    // Handle slider value change event and calculate bounce rate
    func slided(_ sender: UISlider) {
        rate = (Double)(sender.value * sender.value * sender.value * 2.8 + 0.05)
    }
    
    func animateImageTransitions() {
        // Update any changed view (mainly for the slider)
        UIView.animate(withDuration: 0, delay: 0, options: [], animations: {
            self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in})
        
        // Change objects' constraint and update their layout with options
        superMarioTopConstraint.constant -= 80
        UIView.animate(withDuration: rate, delay: 0, options: [.curveEaseOut,.repeat,.autoreverse], animations: {
            self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in})
        dvTopConstraint.constant -= 400
        UIView.animate(withDuration: rate*2, delay: rate, options: [.curveLinear,.repeat], animations: {
            self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in})
        dvStaticTopConstraint.constant -= 30
        UIView.animate(withDuration: rate, delay: rate, options: [.curveEaseOut,.repeat,.autoreverse], animations: {
            self.view.layoutIfNeeded()
            }, completion: {(Bool) -> Void in})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        superMario.image = UIImage(named: "SuperMario")
        
        // Make a attributed string showing hobbies at the bottom of the screen
        let hobbyFont = UIFont(name: "Bradley Hand", size: 30.0)
        let hobbyAttritubes = [
            NSFontAttributeName: hobbyFont!
            ,NSForegroundColorAttributeName: UIColor.red
            ,NSStrokeColorAttributeName: UIColor.black
            ,NSStrokeWidthAttributeName: -1
            ] as [String : Any]
        hobbyLabel.attributedText = NSAttributedString(string: "Play video games", attributes: hobbyAttritubes)
        dv.backgroundColor = UIColor.clear
        dvStatic.backgroundColor = UIColor.clear
        
        // Set a slider to change animation bounce rate
        rateSlide.addTarget(self, action: #selector(SecondViewController.slided(_:)), for: .valueChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //if self.isBeingDismissed {
        //    self.delegate?.acceptData("Flip back to detail page" as AnyObject!)
        //}
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
}
