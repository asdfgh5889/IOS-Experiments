//
//  NetworkController.swift
//  Experiments
//
//  Created by Sherzod on 7/12/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import UIKit

class NetworkControllerExample: UIViewController
{
    @IBAction func test()
    {
        NetworkController.test()
    }
}

class NetworkController
{
    static func test()
    {
        var urlComponent = URLComponents(string: "https://test.com/")!
        urlComponent.path = "/api//user/"
        urlComponent.query = "test"
        
        var queryItmes = [URLQueryItem]()
        queryItmes.append(URLQueryItem(name: "TestQuery", value: "TestValue"))
        
        urlComponent.queryItems = queryItmes
        
        var request = URLRequest(url: urlComponent.url!)
        
        print(urlComponent.host!)
        print(urlComponent.url!)
    }
}
