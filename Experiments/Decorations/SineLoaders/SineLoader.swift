//
//  SineLoader.swift
//  Experiments
//
//  Created by Sherzod on 7/23/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

class SineLoaderExample: UIViewController
{
    var wave = [SineWaveLine]()
    var timer: Timer?
    var waveCount = 5
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        let view = UIView(frame: frame)
        view.center = self.view.center
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 100
        view.backgroundColor = .white
        self.view.addSubview(view)
        
        SineWaveLine.prepareAnimationPaths(frame)
        for i in 0..<waveCount
        {
            let sine = SineWaveLine(frame)
            sine.strokeColor = UIColor.black.cgColor
            sine.endValue = i * SineWaveLine.animPaths.count / (waveCount)
            //sine.timingFunction = CAMediaTimingFunction(controlPoints: Float(i * 2 / waveCount), 0.5, 1 - Float(i * 2 / waveCount), 0.5)
            sine.animationDuration = 4
            sine.repeatCount = 5
            self.wave.append(sine)
            view.layer.addSublayer(sine)
        }
    }
    
    @IBAction func animate()
    {
        self.wave.forEach { $0.animate() }
    }
    
    
}

class SineWaveLine: CAShapeLayer
{
    var endValue: Int = 0
    var animationDuration: Double = 10
    static var animationSampleRate: Double = 150.0
    static var animPaths = [UIBezierPath]()
    
    fileprivate var timingFunction = CAMediaTimingFunction(controlPoints: 0.7, 0.9, 0.7, 0.9)
    
    override init()
    {
        super.init()
    }
    
    convenience init(_ frame: CGRect)
    {
        self.init()
        self.frame = frame
        
        self.path = SineWaveLine.animPaths.first?.cgPath
        self.fillColor = nil
    }
    
    static func prepareAnimationPaths(_ frame: CGRect)
    {
        let width = Double(frame.width)
        let height = Double(frame.height)
        let radius = Double(width / 2)
        let period = 2 * Double.pi
        
        for s in stride(from: 0, through: period, by: period / animationSampleRate)
        {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: height / 2))
            for x in stride(from: 0, through: width, by: width / 100)
            {
                let y = (sqrt(pow(radius, 2) - pow(x - radius, 2))) * (sin(s + (x - radius) * 2 * Double.pi / width)) + radius
                path.addLine(to: CGPoint(x: x, y: y))
            }
            animPaths.append(path)
        }
    }
    
    func animate()
    {
        print(self.endValue)
        let group = CAAnimationGroup()
        group.duration = self.animationDuration
        group.animations = [CAAnimation]()
        //group.timingFunction = self.timingFunction
        group.repeatCount = self.repeatCount
        
        print("Next Animation: \(self.endValue)")
        for i in 1..<SineWaveLine.animPaths.count
        {
            let animation = CABasicAnimation(keyPath: "path")
            animation.fromValue = SineWaveLine.animPaths[i - 1].cgPath
            animation.toValue = SineWaveLine.animPaths[i].cgPath
            
            if i <= self.endValue
            {
                animation.beginTime = Double(i - 1) * self.animationDuration / Double(self.endValue * 2)
                //animation.duration = self.animationDuration / Double(self.endValue * 2)
            }
            else
            {
                animation.beginTime = self.animationDuration / 2 +  Double(i - self.endValue - 1) * self.animationDuration / Double((SineWaveLine.animPaths.count - self.endValue) * 2)
                //animation.duration = self.animationDuration / Double((SineWaveLine.animPaths.count - self.endValue) * 2)
            }
            print(animation.beginTime)
            group.animations?.append(animation)
        }
        self.add(group, forKey: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}

class SineLoader
{
    
}
