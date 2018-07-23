//
//  Constraints.swift
//  Experiments
//
//  Created by Sherzod on 6/19/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

extension UIView
{
    func snapShotImage() -> UIImage?
    {
        return self.snapShotImage(self.frame.size)
    }
    
    func snapShotImage(_ size: CGSize) -> UIImage?
    {
        UIGraphicsBeginImageContext(self.frame.size)
        if let context = UIGraphicsGetCurrentContext()
        {
            self.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        }
        
        return nil
    }
}

class Constraint
{
    static func stickToTop(_ superview: UIView, _ subview: UIView, _ constant: CGFloat = 0, _ multiplier: CGFloat = 1) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: subview, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: multiplier, constant: constant)
    }
    
    static func stickToBottom(_ superview: UIView, _ subview: UIView, _ constant: CGFloat = 0, _ multiplier: CGFloat = 1) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: subview, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: multiplier, constant: constant)
    }
    
    static func stickToLeft(_ superview: UIView, _ subview: UIView, _ constant: CGFloat = 0, _ multiplier: CGFloat = 1) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: subview, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: multiplier, constant: constant)
    }
    
    static func stickToRight(_ superview: UIView, _ subview: UIView, _ constant: CGFloat = 0, _ multiplier: CGFloat = 1) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: subview, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: multiplier, constant: constant)
    }
    
    static func stickToSides(_ superview: UIView, _ subview: UIView) -> [NSLayoutConstraint]
    {
        return [
            Constraint.stickToTop(superview, subview),
            Constraint.stickToBottom(superview, subview),
            Constraint.stickToLeft(superview, subview),
            Constraint.stickToRight(superview, subview)
        ]
    }
    
    static func height(_ view: UIView, _ height: CGFloat) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
    }
    
    static func width(_ view: UIView, _ width: CGFloat) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
    }
    
    static func square(_ view: UIView) -> NSLayoutConstraint
    {
        return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
    }
}
