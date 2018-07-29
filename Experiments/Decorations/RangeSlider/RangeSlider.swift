//
//  RangeSlider.swift
//  Experiments
//
//  Created by Sherzod on 7/26/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class RangeSliderExample: UIViewController
{
    @IBOutlet var rangeSlider: RangeSlider!
    @IBOutlet var min: UILabel!
    @IBOutlet var max: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func show()
    {
        min.text = rangeSlider.currentMinValue.description
        max.text = rangeSlider.currentMaxValue.description
    }
}

@IBDesignable
class LabelWP: UILabel
{
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}

@IBDesignable
class RangeSlider: UIView
{
    @IBInspectable var leftPrefix: String = ""
    @IBInspectable var leftSufix: String = ""
    @IBInspectable var rightPrefix: String = ""
    @IBInspectable var rightSufix: String = ""
    @IBInspectable var minValue: CGFloat = 0
    @IBInspectable var maxValue: CGFloat = 100
    
    @IBInspectable var primaryColor: UIColor = .blue {
        didSet {
            if self.primarySlide != nil
            {
                self.primarySlide.backgroundColor = self.primaryColor
            }
        }
    }
    @IBInspectable var secondaryColor: UIColor = .red {
        didSet {
            if self.primarySlide != nil
            {
                self.secondarySlide.backgroundColor = self.secondaryColor
            }
        }
    }
    @IBInspectable var sliderColor: UIColor = .blue {
        didSet {
            if self.rightSlider != nil && self.leftSlider != nil
            {
                self.rightSlider.backgroundColor = sliderColor
                self.leftSlider.backgroundColor = sliderColor
            }
        }
    }
    
    @IBInspectable var sliderDiameter: CGFloat = 20 {
        didSet {
            if self.leftHeight != nil && self.rightHeight != nil
            {
                self.leftHeight.constant = sliderDiameter
                self.rightHeight.constant = sliderDiameter
            }
        }
    }
    
    fileprivate (set) var currentMinValue: CGFloat = 0.0
    fileprivate (set) var currentMaxValue: CGFloat = 0.0
    
    fileprivate var currentMinValueLabel: UILabel!
    fileprivate var currentMaxValueLabel: UILabel!
    fileprivate var currentMinValueBadge: LabelWP!
    fileprivate var currentMaxValueBadge: LabelWP!
    fileprivate var leftSlider: UIView!
    fileprivate var rightSlider: UIView!
    fileprivate var primarySlide: UIView!
    fileprivate var secondarySlide: UIView!
    fileprivate var rightConstraint: NSLayoutConstraint!
    fileprivate var leftConstraint: NSLayoutConstraint!
    fileprivate var rightHeight: NSLayoutConstraint!
    fileprivate var leftHeight: NSLayoutConstraint!
    fileprivate var difference: CGFloat {
        get {
            return maxValue - minValue
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initSlider()
    }
    
    func initSlider()
    {
        self.leftSlider = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.rightSlider = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.primarySlide = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.secondarySlide = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        self.currentMinValueLabel = UILabel()
        self.currentMaxValueLabel = UILabel()
        self.currentMaxValueBadge = LabelWP()
        self.currentMinValueBadge = LabelWP()
        
        self.leftSlider.translatesAutoresizingMaskIntoConstraints = false
        self.rightSlider.translatesAutoresizingMaskIntoConstraints = false
        self.primarySlide.translatesAutoresizingMaskIntoConstraints = false
        self.secondarySlide.translatesAutoresizingMaskIntoConstraints = false
        self.currentMinValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentMaxValueLabel.translatesAutoresizingMaskIntoConstraints = false
        self.currentMaxValueBadge.translatesAutoresizingMaskIntoConstraints = false
        self.currentMinValueBadge.translatesAutoresizingMaskIntoConstraints = false
        
        self.primarySlide.backgroundColor = self.primaryColor
        self.secondarySlide.backgroundColor = self.secondaryColor
        
        self.addSubview(self.secondarySlide)
        self.addSubview(self.primarySlide)
        self.addSubview(self.rightSlider)
        self.addSubview(self.leftSlider)
        self.addSubview(self.currentMinValueLabel)
        self.addSubview(self.currentMaxValueLabel)
        self.addSubview(self.currentMaxValueBadge)
        self.addSubview(self.currentMinValueBadge)
        
        self.rightConstraint = self.rightSlider.rightAnchor.constraint(equalTo: self.rightAnchor)
        self.leftConstraint = self.leftSlider.leftAnchor.constraint(equalTo: self.leftAnchor)
        
        self.rightHeight = self.rightSlider.heightAnchor.constraint(equalToConstant: sliderDiameter)
        self.leftHeight = self.leftSlider.heightAnchor.constraint(equalToConstant: sliderDiameter)
        
        self.addConstraints([
            self.secondarySlide.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.secondarySlide.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.primarySlide.rightAnchor.constraint(equalTo: self.rightSlider.centerXAnchor),
            self.primarySlide.leftAnchor.constraint(equalTo: self.leftSlider.centerXAnchor),
            self.secondarySlide.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.primarySlide.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.rightSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.leftSlider.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.secondarySlide.heightAnchor.constraint(equalToConstant: 5),
            self.primarySlide.heightAnchor.constraint(equalToConstant: 5),
            self.rightConstraint,
            self.leftConstraint,
            self.rightHeight,
            self.leftHeight,
            self.rightSlider.widthAnchor.constraint(equalTo: self.rightSlider.heightAnchor, multiplier: 1),
            self.leftSlider.widthAnchor.constraint(equalTo: self.leftSlider.heightAnchor, multiplier: 1),
            self.currentMinValueLabel.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.currentMaxValueLabel.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.currentMinValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.currentMaxValueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.currentMinValueBadge.centerXAnchor.constraint(equalTo: self.leftSlider.centerXAnchor),
            self.currentMaxValueBadge.centerXAnchor.constraint(equalTo: self.rightSlider.centerXAnchor),
            self.currentMinValueBadge.bottomAnchor.constraint(equalTo: self.leftSlider.topAnchor, constant: -10),
            self.currentMaxValueBadge.bottomAnchor.constraint(equalTo: self.rightSlider.topAnchor, constant: -10),
            ])
        
        self.secondarySlide.layer.masksToBounds = true
        self.secondarySlide.layer.cornerRadius = 2.5
        
        self.rightSlider.layer.masksToBounds = true
        self.leftSlider.layer.masksToBounds = true
        
        self.rightSlider.layer.cornerRadius = 9
        self.leftSlider.layer.cornerRadius = 9
        
        self.rightSlider.backgroundColor = self.sliderColor
        self.leftSlider.backgroundColor = self.sliderColor
        
        self.leftSlider.tag = 0
        self.rightSlider.tag = 1
        
        self.currentMinValueLabel.text = self.minValue.description
        self.currentMaxValueLabel.text = self.maxValue.description
        
        self.currentMinValueBadge.isHidden = true
        self.currentMaxValueBadge.isHidden = true
        
        self.currentMinValueBadge.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.currentMaxValueBadge.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.currentMinValueBadge.layer.masksToBounds = true
        self.currentMaxValueBadge.layer.masksToBounds = true
        
        self.currentMinValueBadge.layer.cornerRadius = 6
        self.currentMaxValueBadge.layer.cornerRadius = 6
        
        self.currentMinValueBadge.textColor = .white
        self.currentMaxValueBadge.textColor = .white
        
        self.rightSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sliderGesture(pan:))))
        self.leftSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(sliderGesture(pan:))))
    }
    
    fileprivate var lastConstant: CGFloat = 0
    @objc fileprivate func sliderGesture(pan: UIPanGestureRecognizer)
    {
        if pan.state == .began
        {
            if pan.view!.tag == 0
            {
                lastConstant = self.leftConstraint.constant
                self.leftHeight.constant *= 1.5
            }
            else
            {
                self.rightHeight.constant *= 1.5
                lastConstant = self.rightConstraint.constant
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
                self.leftSlider.layer.cornerRadius = self.leftHeight.constant / 2
                self.rightSlider.layer.cornerRadius = self.rightHeight.constant / 2
                self.currentMinValueBadge.isHidden = pan.view!.tag != 0
                self.currentMaxValueBadge.isHidden = pan.view!.tag == 0
            }
        }
        else if pan.state == .ended
        {
            if pan.view!.tag == 0
            {
                self.leftHeight.constant /= 1.5
            }
            else
            {
                self.rightHeight.constant /= 1.5
            }
            
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
                self.leftSlider.layer.cornerRadius = self.leftHeight.constant / 2
                self.rightSlider.layer.cornerRadius = self.rightHeight.constant / 2
                self.currentMinValueBadge.isHidden = true
                self.currentMaxValueBadge.isHidden = true
            }
        }
        
        let step = lastConstant + pan.translation(in: self).x
        
        switch pan.view!.tag
        {
        case 0:
            if step + sliderDiameter <= self.rightSlider.frame.origin.x
            { self.leftConstraint.constant = step >= 0 ? step : 0 }
        case 1:
            if self.frame.width + step >= self.leftSlider.frame.origin.x + sliderDiameter * 2
            { self.rightConstraint.constant = step <= 0 ? step : 0 }
        default:
            print()
        }
        
        self.currentMinValue = CGFloat(round(self.minValue + self.difference * (self.leftSlider.center.x - self.sliderDiameter / 2) / self.frame.width) * 10) / 10
        self.currentMaxValue = CGFloat(round(self.minValue + self.difference * (self.rightSlider.center.x + self.sliderDiameter / 2) / self.frame.width) * 10) / 10
        
        self.currentMinValueBadge.text = self.currentMinValue.description
        self.currentMaxValueBadge.text = self.currentMaxValue.description
        self.currentMinValueLabel.text = "\(self.leftPrefix) \(self.currentMinValue.description) \(self.leftSufix)"
        self.currentMaxValueLabel.text = "\(self.rightPrefix) \(self.currentMaxValue.description) \(self.rightSufix)"
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.initSlider()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
