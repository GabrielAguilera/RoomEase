//
//  WelcomeViewController.swift
//  RoomEase
//
//  Created by Jessica Aboukasm on 4/11/16.
//  Copyright © 2016 RoomEase - EECS 441. All rights reserved.
//

import Foundation
import UIKit


class WelcomeUIViewController: UIViewController {
    
    @IBOutlet weak var WelcomeLabel: UILabel!

    @IBOutlet weak var joinLabel: UIButton!

    @IBOutlet weak var createLabel: UIButton!
   
    
    override func viewDidLoad()  {
        self.WelcomeLabel.hidden = true
        self.joinLabel.hidden = true
        self.createLabel.hidden = true
    
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "stairsLoft.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(imageViewBackground)
        self.view.sendSubviewToBack(imageViewBackground)
        
        imageFadeIn(imageViewBackground)
  
        
        
        
        self.WelcomeLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.WelcomeLabel.hidden = false
            self.WelcomeLabel.fadeIn()
        })
        
        self.joinLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.joinLabel.hidden = false
            self.joinLabel.fadeIn()
        })
        
        self.createLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.createLabel.hidden = false
            self.createLabel.fadeIn()
        })
        

        
    }
    
    
    func imageFadeIn(imageView: UIImageView) {
        
        let secondImageView = UIImageView(image: imageView.image)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = secondImageView.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        secondImageView.addSubview(blurEffectView)
        secondImageView.alpha = 0.0

        view.insertSubview(secondImageView, aboveSubview: imageView)
        
        UIView.animateWithDuration(3.0, delay: 2.0, options: .CurveEaseOut, animations: {
            secondImageView.alpha = 1.0
            }, completion: {_ in
                imageView.image = secondImageView.image
               // secondImageView.removeFromSuperview()
        })
        
    }
    


    
    
    
    
} // welcome UI


extension UIView {
    func fadeIn(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.5, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 0.5, delay: NSTimeInterval = 0.5, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }

    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "stairsLoft.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
       // self.addBlur(imageViewBackground)
        
    }
    
    func addBlur(imageViewBackground: UIImageView) {
        
        
        UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageViewBackground.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageViewBackground.addSubview(blurEffectView)
            
                 }, completion: nil)

    }
   
   

}
