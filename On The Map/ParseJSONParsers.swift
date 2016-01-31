//
//  JSONParsers.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

class ParseJSONParsers {
    
    // MARK: - METHODS
    
    // MARK: - Getting student locations
    
    /**
    The JSON should contain an array of StudentInformation structs
    
    - parameter data: Data got from Parse server after sending a get student locations request
    
    - throws: GetStudentLocationsParsingError
    
    - returns: An array of StudentInformation structs
    */
    
    func parseJSONForGettingStudentLocations(data: NSData) throws -> [StudentInformation] {
        
        var studentInformations = [StudentInformation]()
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        guard let results = parsedJSON["results"] as? [NSDictionary] else { throw Errors.GetStudentLocationsParsingError}
        
        for result in results {
            
            guard let firstName = result["firstName"] as? String else { break }
            guard let lastName = result["lastName"] as? String else  { break }
            
            guard let latitude = result["latitude"] as? Double else  { break }
            guard (latitude >= -90) && (latitude <= 90) else { break }
            
            guard let longitude = result["longitude"] as? Double else  { break }
            guard (longitude >= -180) && (longitude <= 180) else { break }
            
            guard let mapString = result["mapString"] as? String else  { break }
            guard let mediaURL = result["mediaURL"] as? String else  { break }
            guard let objectId = result["objectId"] as? String else  { break }
            guard let uniqueKey = result["uniqueKey"] as? String else  { break }
            
            var studentInfoDictionary = [String: AnyObject]()
            
            studentInfoDictionary["objectId"] = objectId
            studentInfoDictionary["uniqueKey"] = uniqueKey
            studentInfoDictionary["firstName"] = firstName
            studentInfoDictionary["lastName"] = lastName
            studentInfoDictionary["mapString"] = mapString
            studentInfoDictionary["mediaURL"] = mediaURL
            studentInfoDictionary["latitude"] = latitude
            studentInfoDictionary["longitude"] = longitude
            
            
            let studentInformation = StudentInformation(studentInfoDictionary: studentInfoDictionary)
            
            studentInformations.append(studentInformation)
            
        }
        
        return studentInformations
    }
    
    
    
    // MARK: - Posting student location
    
    /**
    The JSON should contain a nonempty "objectId" element
    
    - parameter data: Data got from Parse server after sending an update student location request
    
    - throws: PostStudentLocationParsingError
    */
    func parseJSONForPostingStudentLocation(data: NSData) throws {
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        guard let objectId = parsedJSON["objectId"] as? String else { throw Errors.PostStudentLocationParsingError }
        guard !objectId.isEmpty else { throw Errors.PostStudentLocationParsingError }
        
        
    }
    
    
    
    // MARK: - Querying for a student location
    
    /**
    The JSON should contain a StudentInformation struct
    
    - parameter data: Data got from Parse server after querying for a student location
    
    - throws: Error propagated from the parseJSONForGettingStudentLocations method
    
    - returns: Nil if the logged-in student did not enter previously a location. StudentInformation struct if the logged-in student entered previously a location.
    */
    func parseJSONForQueryingStudentLocation(data: NSData) throws -> StudentInformation? {
        
        let studentInformations = try parseJSONForGettingStudentLocations(data)
        
        if studentInformations.isEmpty {
            
            return nil
            
        } else {
            
            return studentInformations[0]
            
        }
        
    }
    
    
    // MARK: - Updating a student location
    
    /**
    The JSON should contain a dictionary with "updatedAt" element
    
    - parameter data: Data got from Parse server after sending an update student location request
    
    - throws: UpdatingStudentLocationParsingError
    */
    func parseJSONForUpdatingStudentLocation(data: NSData) throws {
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        
        guard let updatedAt = parsedJSON["updatedAt"] as? String else { throw Errors.UpdatingStudentLocationParsingError }
        guard !updatedAt.isEmpty else { throw Errors.UpdatingStudentLocationParsingError }
        
        
    }
    
}

