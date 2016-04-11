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
        self.WelcomeLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.WelcomeLabel.fadeIn()
        })
        
        self.joinLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.joinLabel.fadeIn()
        })
        
        self.createLabel.fadeOut(completion: {
            (finished: Bool) -> Void in
            self.createLabel.fadeIn()
        })

        self.view.addBackground()

    }
    
    
} // welcome UI


extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.5, delay: NSTimeInterval = 1.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.5, delay: NSTimeInterval = 1.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
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
        self.addBlur(imageViewBackground)
   
    }
    
    func addBlur(imageViewBackground: UIImageView) {
        
        
        UIView.animateWithDuration(1.0, delay: 5.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            
       

        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageViewBackground.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageViewBackground.addSubview(blurEffectView)
            
                 }, completion: nil)

    }
   
    
   

}
