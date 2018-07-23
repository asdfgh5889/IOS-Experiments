//
//  Controller.swift
//  Experiments
//
//  Created by Sherzod on 3/9/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class Controller: UIViewController
{
    @IBOutlet var top: NSLayoutConstraint!
    @IBOutlet var height: NSLayoutConstraint!
    @IBOutlet var width: NSLayoutConstraint!
    @IBOutlet var btn: UIButton!
    var initPoint: CGPoint!
    var secondPoint: CGPoint!
    
    override func viewDidLoad() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(touchDismiss(_:)))
        self.btn.addGestureRecognizer(gesture)
        self.initPoint = self.btn.frame.origin
        self.secondPoint = self.btn.frame.origin
    }
    
    var relativePoint: CGPoint = CGPoint(x: 0, y: 0)
    var returnAnim: Bool = false
    @objc func touchDismiss(_ gesture: UIPanGestureRecognizer)
    {
        if gesture.state == .ended
        {
            if !returnAnim
            {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                    self.btn.frame.origin = self.secondPoint
                }, completion: {(success: Bool) in
                    
                })
            }
            else
            {
                returnAnim = false
                self.top.constant = self.top.constant - 200
                self.width.constant = self.width.constant / 2
                self.height.constant = self.height.constant / 2
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                    self.btn.frame.origin = self.initPoint
                }, completion: {(success: Bool) in
                    self.secondPoint = self.btn.frame.origin
                })
            }
        }
        else if gesture.state == .began
        {
            returnAnim = false
            let point = gesture.location(in: self.view)
            relativePoint = CGPoint(x: point.x - btn.frame.origin.x, y: point.y - btn.frame.origin.y)
        }
        else
        {
            let absolutePoint = gesture.location(in: self.view)
            let touchPoint = CGPoint(x: absolutePoint.x - relativePoint.x, y: absolutePoint.y - relativePoint.y)
            btn.frame.origin = touchPoint
            
            let movePoint = gesture.translation(in: self.view)
            if abs(movePoint.x) >= 50 || abs(movePoint.y) >= 50
            {
                returnAnim = true
            }
        }
    }
    
    @IBAction func animate(_ sender: UIButton)
    {
        self.top.constant = self.top.constant + 200
        
        self.width.constant = self.width.constant * 2
        self.height.constant = self.height.constant * 2
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: {(success: Bool) in
            self.secondPoint = self.btn.frame.origin
        })
    }
}
