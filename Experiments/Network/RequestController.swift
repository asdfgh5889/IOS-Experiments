//
//  RequestController.swift
//  Experiments
//
//  Created by Sherzod on 7/12/18.
//  Copyright © 2018 Sherzod. All rights reserved.
//

import Foundation

enum HTTPMethods: String
{
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

class RequestController
{
    static var baseURL = ""
    static var baseAPIPath = ""
    
    
    static func generateRequest(_ postData: PostDataProtocol) -> URLRequest?
    {
        guard let url = makeURL(postData.getPath(), postData) else
        {
            return nil
        }
        return makeURLRequest(url, postData)
    }
    
    static func makeURL(_ method: String , _ postData: PostDataProtocol) -> URL?
    {
        guard var urlComponents = URLComponents(string: baseURL) else
        {
            return nil
        }
        
        urlComponents.path = "\(baseAPIPath)\(method)"
        
        if let items = postData.getQueryItems()
        {
            urlComponents.queryItems = [URLQueryItem]()
            for item in items
            {
                urlComponents.queryItems!.append(item)
            }
        }
        
        return urlComponents.url
    }
    
    static func makeURLRequest(_ url: URL, _ postData: PostDataProtocol) -> URLRequest
    {
        var request = URLRequest(url: url)
        
        request.httpMethod = postData.getMethod().rawValue
        if(JSONSerialization.isValidJSONObject(postData.getJsonBody() as Any))
        {
            do
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: postData.getJsonBody()!)
            }
            catch
            {
                print("Invalid Json Data!")
            }
        }
        else
        {
            print("Invalid Json Data!")
        }
        
        return request
    }
}
