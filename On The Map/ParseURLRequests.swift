//
//  ParseURLRequests.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import Foundation

class ParseURLRequests {
    
    // MARK: - CONSTANTS
    
    // Parse method url
    let parseMethodUrlString = "https://api.parse.com/1/classes/StudentLocation"
    
    // Parse Application ID and API Key
    let parseAppId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let parseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    // Parse HTTPHeaderFiels
    let applicationId = "X-Parse-Application-Id"
    let restApiKey = "X-Parse-REST-API-Key"
    
    
    // MARK: - PARSE REQUESTS
    
    // MARK: - Get student locations
    func getStudentLocationsRequest() -> NSMutableURLRequest {
        
        // Request URL
        let requestURLComponents = NSURLComponents(string: parseMethodUrlString)!
        
        let limit = NSURLQueryItem(name: "limit", value: "100")
        let order = NSURLQueryItem(name: "order", value: "-updatedAt")
        requestURLComponents.queryItems = [limit, order]
        
        let requestURL = requestURLComponents.URL!
        
        let request = NSMutableURLRequest(URL: requestURL)
        
        // HTTP header
        request.addValue(parseAppId, forHTTPHeaderField: applicationId)
        request.addValue(parseRestApiKey, forHTTPHeaderField: restApiKey)
        
        return request
    }
    
    
    // MARK: - Post a student location
    func postStudentLocationRequest(studentInformation: StudentInformation) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: parseMethodUrlString)!)
        
        // HTTP header
        request.HTTPMethod = "POST"
        request.addValue(parseAppId, forHTTPHeaderField: applicationId)
        request.addValue(parseRestApiKey, forHTTPHeaderField: restApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        // HTTP body
        let httpBodyDictionary = [
            "uniqueKey": studentInformation.uniqueKey,
            "firstName": studentInformation.firstName,
            "lastName": studentInformation.lastName,
            "mapString": studentInformation.mapString,
            "mediaURL": studentInformation.mediaURL,
            "latitude": Double(studentInformation.latitude),
            "longitude": Double(studentInformation.longitude)]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(httpBodyDictionary, options: NSJSONWritingOptions())
        
        return request
    }
    
    
    // MARK: - Query a student location
    func queryStudentLocationRequest(uniqueKey uniqueKey: String) -> NSMutableURLRequest {
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22"+uniqueKey+"%22%7D"
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        request.addValue(parseAppId, forHTTPHeaderField: applicationId)
        request.addValue(parseRestApiKey, forHTTPHeaderField: restApiKey)
        
        return request
    }
    
    
    // MARK: - Update a student location
    func updateStudentLocationRequest(studentInformation studentInformation: StudentInformation) -> NSMutableURLRequest {
        
        let urlString = parseMethodUrlString + "/" + studentInformation.objectId!
        let url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url!)
        
        // Http header
        request.HTTPMethod = "PUT"
        request.addValue(parseAppId, forHTTPHeaderField: applicationId)
        request.addValue(parseRestApiKey, forHTTPHeaderField: restApiKey)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // HTTP body
        let httpBodyDictionary = [
            "uniqueKey": studentInformation.uniqueKey,
            "firstName": studentInformation.firstName,
            "lastName": studentInformation.lastName,
            "mapString": studentInformation.mapString,
            "mediaURL": studentInformation.mediaURL,
            "latitude": Double(studentInformation.latitude),
            "longitude": Double(studentInformation.longitude)]
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(httpBodyDictionary, options: NSJSONWritingOptions())
        
        return request
    }
    
}

