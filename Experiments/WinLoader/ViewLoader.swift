//
//  ViewLoader.swift
//  Experiments
//
//  Created by Sherzod on 6/28/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class ViewLoaderExample: UIViewController
{
    @IBAction func startLoader()
    {
        ViewLoader.showLoaderView(for: self.view)
    }
    
    @IBAction func stopLoader()
    {
        ViewLoader.hideLoaderView(for: self.view)
    }
}

class ViewLoader
{
    fileprivate static var loaderViews = [Int:UIView]()
    fileprivate static var loaderViewSize: CGSize = CGSize(width: 65, height: 65)
    
    
    static func showLoaderView(for view: UIView)
    {
        if loaderViews[view.hashValue] == nil
        {
            let loaderView = UIVisualEffectView(frame: CGRect(origin: view.center, size: loaderViewSize))
            loaderView.effect = UIBlurEffect(style: .light)
            loaderView.translatesAutoresizingMaskIntoConstraints = false
            loaderView.clipsToBounds = true
            loaderView.layer.cornerRadius = 8
            
            let loader = WinLoader(UIColor.darkGray)
            loader.translatesAutoresizingMaskIntoConstraints = false
            
            loaderView.contentView.addSubview(loader)
            
            loaderView.contentView.addConstraints([
                loader.centerXAnchor.constraint(equalTo: loaderView.contentView.centerXAnchor),
                loader.centerYAnchor.constraint(equalTo: loaderView.contentView.centerYAnchor)
                ])
            loader.startAnimation()
            view.addSubview(loaderView)
            
            view.addConstraints([
                loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                loaderView.heightAnchor.constraint(equalToConstant: loaderViewSize.height),
                loaderView.widthAnchor.constraint(equalToConstant: loaderViewSize.width)
                ])
            loaderViews[view.hashValue] = loaderView
        }
    }
    
    static func hideLoaderView(for view: UIView)
    {
        if loaderViews[view.hashValue] != nil
        {
            loaderViews[view.hashValue]?.removeFromSuperview()
            loaderViews.removeValue(forKey: view.hashValue)
        }
    }
}
