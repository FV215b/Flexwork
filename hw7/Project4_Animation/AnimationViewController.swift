//
//  AnimationViewController.swift
//  jz173-ece590-hw3
//
//  Created by Jianyu Zhang on 9/27/16.
//  Copyright © 2016 Jianyu Zhang. All rights reserved.
//

import UIKit
import AVFoundation

protocol AnimationViewControllerDelegate: class {
    func acceptData(_ data: AnyObject!)
}

class AnimationViewController: UIViewController {
    
    @IBOutlet var returnButton: UIButton!
    @IBOutlet var racketImageView: UIImageView!
    
    var backgroundMusicPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set animation
        racketImageView.image = UIImage(named: "tennis_right")
/*
        let tennis = DrawTennis()
        
        tennis.frame = CGRect(x: 55, y: 300, width: 20, height: 20)
        tennis.backgroundColor = UIColor.white
        
        self.view.addSubview(tennis)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16,y: 239))
        path.addCurve(to: CGPoint(x: 0, y: 239), controlPoint1: CGPoint(x: 220, y: 239), controlPoint2: CGPoint(x: 320, y: 239))
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        anim.path = path.cgPath
        
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        
        tennis.layer.add(anim, forKey: "animate position along path")   */
        
        super.viewDidLoad()
        
        let tennis = DrawTennis()
        
        tennis.frame = CGRect(x: 55, y: 300, width: 20, height: 20)
        tennis.backgroundColor = UIColor.white
        
        self.view.addSubview(tennis)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 16,y: 239))
        path.addCurve(to: CGPoint(x: 0, y: 239), controlPoint1: CGPoint(x: 220, y: 239), controlPoint2: CGPoint(x: 320, y: 239))
        
        let anim = CAKeyframeAnimation(keyPath: "position")
        
        anim.path = path.cgPath
        
        anim.rotationMode = kCAAnimationRotateAuto
        anim.repeatCount = Float.infinity
        anim.duration = 5.0
        
        tennis.layer.add(anim, forKey: "animate position along path")
        
        playBackgroundMusic("rhythm.mp3")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playBackgroundMusic(_ filename: String) {
        let url = Bundle.main.url(forResource: filename, withExtension: nil)
        guard let newURL = url else {
            print("Could not find file: \(filename)")
            return
        }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: newURL)
            backgroundMusicPlayer.numberOfLoops = -1
            backgroundMusicPlayer.prepareToPlay()
            backgroundMusicPlayer.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    @IBAction func doDismiss(_ sender: AnyObject?) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

