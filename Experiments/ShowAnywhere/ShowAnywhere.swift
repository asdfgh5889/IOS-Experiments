//
//  File.swift
//  Experiments
//
//  Created by Sherzod on 7/1/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

@objc protocol ShowAnywhereDelegate
{
    func getMainView() -> UIView
    @objc func refresh()
}

class ShowAnywhereExample2: UIViewController, ShowAnywhereDelegate
{
    @objc func refresh()
    {
        print("refresh 2")
    }
    
    override func viewDidLoad()
    {
        ShowAnywhere.register(self)
    }
    
    func getMainView() -> UIView
    {
        return self.view
    }
    
    @IBAction func show()
    {
        ShowAnywhere.triggerEvent()
    }
}

class ShowAnywhereExample1: UIViewController, ShowAnywhereDelegate
{
    @objc func refresh()
    {
        print("refresh 1")
    }
    
    override func viewDidLoad()
    {
        ShowAnywhere.register(self)
    }
    
    @IBAction func show()
    {
        ShowAnywhere.triggerEvent()
    }
    
    func getMainView() -> UIView
    {
        return self.view
    }
    
    @IBAction func unregister()
    {
        ShowAnywhere.unregister(self)
    }
}

class ShowAnywhere
{
    fileprivate static var registeredViews = [Int: UIView]()
    fileprivate static var showedViews = [Int: UIView]()
    fileprivate static var registeredDelegate = [Int: ShowAnywhereDelegate]()
    
    static func register(_ delegate: ShowAnywhereDelegate)
    {
        let view = delegate.getMainView()
        if registeredViews[view.hashValue] == nil
        {
            registeredViews[view.hashValue] = view
            registeredDelegate[view.hashValue] = delegate
        }
    }
    
    static func unregister(_ delegate: ShowAnywhereDelegate)
    {
        let view = delegate.getMainView()
        if registeredViews[view.hashValue] != nil
        {
            registeredViews.removeValue(forKey: view.hashValue)
            registeredDelegate.removeValue(forKey: view.hashValue)
        }
    }
    
    static var key = true
    static func triggerEvent()
    {
        for (_ , view) in registeredViews
        {
            if view.window != nil
            {
                if key
                {
                    showView(on: view)
                }
                else
                {
                    removeView(from: view)
                }
                key = !key
            }
        }
    }
    
    fileprivate static func viewToShow(_ delegate: ShowAnywhereDelegate) -> UIView
    {
        let window = UIApplication.shared.keyWindow!
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 100))
        view.center = window.center
        view.backgroundColor = .red
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        btn.setTitle("Refresh", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(delegate, action: #selector(delegate.refresh), for: UIControlEvents.touchDown)
        view.addSubview(btn)
        view.addConstraints([
            btn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        return view
    }
    
    fileprivate static func showView(on view: UIView)
    {
        if showedViews[view.hashValue] == nil
        {
            if registeredViews[view.hashValue] != nil
            {
                let warning = viewToShow(registeredDelegate[view.hashValue]!)
                view.addSubview(warning)
                showedViews[view.hashValue] = warning
            }
            else
            {
                print("View \(view.hashValue) not registered")
            }
        }
    }
    
    fileprivate static func removeView(from view: UIView)
    {
        if showedViews[view.hashValue] != nil
        {
            showedViews[view.hashValue]?.removeFromSuperview()
            showedViews.removeValue(forKey: view.hashValue)
        }
    }
}

