//
//  Stepper.swift
//  Experiments
//
//  Created by Sherzod on 6/26/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class StepperExample: UIViewController
{
    var stepper: Stepper!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
}

class NumberTextField: UITextField, UITextFieldDelegate
{
    convenience init()
    {
        self.init(frame: CGRect.zero)
        self.delegate = self
        self.keyboardType = .numberPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        return Int(string) == nil ? string.first?.unicodeScalars == nil ? true : false : true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.resignFirstResponder()
        return true
    }
}

class Stepper: UIView
{
    var stepUpButton: UIButton!
    var stepDownButton: UIButton!
    var valueLabel: NumberTextField!
    
    var activeColor: UIColor = .blue {
        didSet {
            self.stepDownButton.tintColor = activeColor
            self.stepUpButton.tintColor = activeColor
        }
    }
    
    var value: Int = 0 {
        didSet {
            self.valueLabel.text = value.description
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    convenience init(frame: CGRect, _ initValue: Int)
    {
        self.init(frame: frame)
        self.value = initValue
        self.valueLabel.text = self.value.description
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.initSubviews()
    }
    
    fileprivate func initSubviews()
    {
        self.stepUpButton = UIButton()
        self.stepDownButton = UIButton()
        self.valueLabel = NumberTextField()
        
        self.valueLabel.textAlignment = .center
        self.valueLabel.text = self.value.description
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.stepUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.stepDownButton.translatesAutoresizingMaskIntoConstraints = false
        self.valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stepDownButton)
        self.addSubview(self.stepUpButton)
        self.addSubview(self.valueLabel)
        
        self.addConstraints([
            self.stepDownButton.rightAnchor.constraint(equalTo: self.valueLabel.leftAnchor, constant: -5),
            self.stepDownButton.heightAnchor.constraint(equalTo: self.stepDownButton.widthAnchor, multiplier: 1),
            self.stepDownButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            self.stepDownButton.widthAnchor.constraint(equalToConstant: 22)
            ])
        
        self.addConstraints([
            self.stepUpButton.leftAnchor.constraint(equalTo: self.valueLabel.rightAnchor, constant: 5),
            self.stepUpButton.heightAnchor.constraint(equalTo: self.stepUpButton.widthAnchor, multiplier: 1),
            self.stepUpButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            self.stepUpButton.widthAnchor.constraint(equalToConstant: 22)
            ])
        
        self.addConstraints([
            self.valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            self.valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            ])
        
        self.setUpStepButtons()
        self.setUpValueLabel()
    }
    
    fileprivate func setUpValueLabel()
    {
        self.layoutIfNeeded()
        self.valueLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        
        self.valueLabel.addTarget(self, action: #selector(textValueChanged(_:)), for: UIControlEvents.editingChanged)
    }
    
    fileprivate func setUpStepButtons()
    {
        self.layoutIfNeeded()
        
        self.stepDownButton.backgroundColor = self.activeColor
        self.stepUpButton.backgroundColor = self.activeColor
        
        self.stepUpButton.layer.cornerRadius = stepUpButton.frame.height / 2
        self.stepDownButton.layer.cornerRadius = stepDownButton.frame.height / 2
        
        self.stepUpButton.setTitle("＋", for: UIControlState.normal)
        self.stepDownButton.setTitle("－", for: UIControlState.normal)
        
        self.stepUpButton.titleLabel?.textAlignment = .center
        self.stepDownButton.titleLabel?.textAlignment = .center
        
        self.stepUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        self.stepDownButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        
        self.stepDownButton.addTarget(self, action: #selector(stepDown), for: UIControlEvents.touchDown)
        self.stepUpButton.addTarget(self, action: #selector(stepUp), for: UIControlEvents.touchDown)
    }
    
    @objc fileprivate func stepUp()
    {
        self.value += 1
    }
    
    @objc fileprivate func stepDown()
    {
        if self.value > 0
        {
            self.value -= 1
        }
    }
    
    @objc fileprivate func textValueChanged(_ textField: UITextField)
    {
        self.value = Int(textField.text!) ?? 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
