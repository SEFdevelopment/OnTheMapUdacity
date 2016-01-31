//
//  UdacityURLRequests.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

class UdacityURLRequests {
    
    // MARK: - CONSTANTS
    
    // Udacity method url
    let udacityMethodUrlString = "https://www.udacity.com/api/session"
    
    
    // MARK: - METHODS
    
    // MARK: - Create a session
    func createUdacitySessionRequest(username username: String, password: String) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: udacityMethodUrlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let httpBodyDictionary = ["udacity": ["username": username, "password": password]]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(httpBodyDictionary, options: NSJSONWritingOptions())
        
        return request
        
    }
    
    
    func deleteUdacitySessionRequest() -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: udacityMethodUrlString)!)
        request.HTTPMethod = "DELETE"
        
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            
        }
        
        return request
    }
    
    
    
    func getUdacityPublicUserDataRequest(userId: String) -> NSMutableURLRequest {
        
        let methodUrlString = "https://www.udacity.com/api/users/" + userId
        
        let request = NSMutableURLRequest(URL: NSURL(string: methodUrlString)!)
        
        return request
    }
    
}
