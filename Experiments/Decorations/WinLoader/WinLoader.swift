//
//  WinLoader.swift
//  Experiments
//
//  Created by Sherzod on 6/27/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class WinLoaderExample: UIViewController
{
    @IBOutlet var loader: WinLoader!
    
    @IBAction func start()
    {
        self.loader.startAnimation()
        print(loader.isAnimating)
    }
    
    @IBAction func stop()
    {
        self.loader.stopAnimation()
        print(loader.isAnimating)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}

class LoaderCircle: CAShapeLayer
{
    override init()
    {
        super.init()
        self.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 8, height: 8)).cgPath
        self.fillColor = UIColor.red.cgColor
    }
    
    convenience init(_ frame: CGRect)
    {
        self.init()
        self.frame = frame
        self.path = UIBezierPath(ovalIn: self.frame).cgPath
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

class WinLoader: UIView
{
    var numberOfCircles: Int = 6
    var duration: Double = 1.45
    var color: UIColor = UIColor.red
    var isAnimating: Bool { get { return self.animating } }
    
    fileprivate var animating: Bool = false
    fileprivate var circles = [LoaderCircle]()
    fileprivate var durationRatio: Double = 0.65
    fileprivate var angleRatio: Double = 0.42
    fileprivate var offsetDuration: Double = 0.18
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
        self.addConstraints([
            self.heightAnchor.constraint(equalToConstant: 22),
            self.widthAnchor.constraint(equalToConstant: 22)
            ])
    }
    
    convenience init(_ color: UIColor)
    {
        self.init()
        self.color = color
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func startAnimation()
    {
        if !self.animating
        {
            self.animating = true
            offsetDuration = duration * 0.12
            for i in 0 ..< self.numberOfCircles
            {
                let circle = LoaderCircle(CGRect(x: 0, y: 0, width: 4, height: 4))
                circle.fillColor = UIColor.clear.cgColor
                circle.bounds = self.bounds
                circle.anchorPoint = CGPoint(x: 0, y: -0.5)
                circle.frame.origin = CGPoint(x: self.frame.width / 2, y: self.frame.height)
                
                self.circles.append(circle)
                
                let fade = CABasicAnimation(keyPath: "fillColor")
                fade.toValue = color.cgColor
                fade.duration = 0.05
                fade.isRemovedOnCompletion = true
                fade.fillMode = kCAFillModeForwards
                
                let rotation1 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation1.fromValue = 0
                rotation1.toValue = CGFloat.pi / 2
                rotation1.duration = (duration * (1 - durationRatio)) / 2
                rotation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                
                let rotation2 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation2.fromValue = CGFloat.pi / 2
                rotation2.toValue = 2 * Double.pi * (0.25 + angleRatio)
                rotation2.duration = duration * durationRatio
                rotation2.beginTime = (duration * (1 - durationRatio)) / 2
                
                let rotation3 = CABasicAnimation(keyPath: "transform.rotation.z")
                rotation3.fromValue = 2 * Double.pi * (0.25 + angleRatio)
                rotation3.toValue =  2 * CGFloat.pi
                rotation3.duration = (duration * (1 - durationRatio)) / 2
                rotation3.beginTime = (duration * (1 + durationRatio)) / 2
                rotation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
                
                let rotation = CAAnimationGroup()
                rotation.duration = duration
                rotation.repeatCount = 2
                rotation.animations = [fade, rotation1, rotation2, rotation3]
                
                let cycle = CAAnimationGroup()
                cycle.animations = [rotation]
                cycle.duration = duration * 2 + Double(self.numberOfCircles) * offsetDuration + 0.3
                cycle.repeatCount = Float.greatestFiniteMagnitude
                cycle.beginTime = CACurrentMediaTime() + Double(i) * offsetDuration
                
                self.layer.addSublayer(circle)
                circle.add(cycle, forKey: "loading")
            }
        }
    }
    
    func stopAnimation()
    {
        if self.animating
        {
            self.animating = false
            for circle in self.circles
            {
                circle.removeAllAnimations()
                circle.removeFromSuperlayer()
            }
            self.circles.removeAll()
        }
    }
}
