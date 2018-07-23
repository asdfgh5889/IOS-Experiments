//
//  NetworkProtocols.swift
//  Experiments
//
//  Created by Sherzod on 7/12/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import Foundation

protocol PostDataProtocol
{
    typealias QueryItems = [URLQueryItem]
    typealias HeaderItems = [String:String?]
    typealias JsonBody = [String: Any]
    
    func getQueryItems() -> QueryItems?
    func getJsonBody() -> JsonBody?
    func getPath() -> String
}

extension PostDataProtocol
{
    func getHeaderItmes() -> HeaderItems?
    {
        return nil
    }
    
    func getMethod() -> HTTPMethods
    {
        return .post
    }
}
