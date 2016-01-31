//
//  UdacityJSONParsers.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

class UdacityJSONParsers {
    
    // MARK: - METHODS
    
    // MARK: - Creating an Udacity session
    
    /**
    The JSON returned from the Udacity server should contain an userId and a registered value of true.
    
    - parameter data: Data got from Udacity server after sending an authorization request to it
    
    - throws: CreatingUdacitySessionParsingError
    
    - returns: User id of the logged-in student.
    */
    func parseJSONForCreatingASession(data: NSData) throws -> String {
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)
        
        guard let account = parsedJSON["account"] as? [String: AnyObject] else { throw Errors.CreatingUdacitySessionParsingError }
        
        guard let registered = account["registered"] as? Bool else { throw Errors.CreatingUdacitySessionParsingError }
        guard registered == true else { throw Errors.CreatingUdacitySessionParsingError }
        
        guard let userId = account["key"] as? String else { throw Errors.CreatingUdacitySessionParsingError }
        
        return userId
        
    }
    
    
    
    // MARK: - Logging out of an Udacity session
    
    /**
    The JSON returned from Udacity server should have a session id.
    
    - parameter data: Data got from Udacity server after sending the delete session request.
    
    - throws: DeletingUdacitySessionError
    
    - returns: True if there is a session id in the JSON.
    */
    func parseJSONForDeletingASession(data: NSData) throws -> Bool {
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)
        
        guard let session = parsedJSON["session"] as? [String: AnyObject] else { throw Errors.DeletingUdacitySessionParsingError }
        
        guard let _ = session["id"] as? String else { throw Errors.DeletingUdacitySessionParsingError }
        
        return true
        
    }
    
    
    // MARK: - Get Udacity public user data
    
    /**
    The JSON returned from Udacity server should contain logged-in user's key, last name and first name.
    
    - parameter data: Data got from Udacity server after sending the request for getting user's public data.
    
    - throws: GetUdacityPublicUserDataParsingError
    
    - returns: StudentPublicData struct containing logged-in user's key, last name and first name.
    */
    func parseJSONForGettingPublicUserData(data: NSData) throws -> StudentPublicData {
        
        let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
        
        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments)
        
        guard let user = parsedJSON["user"] as? [String: AnyObject] else { throw Errors.GetUdacityPublicUserDataParsingError }
        
        guard let key = user["key"] as? String else { throw Errors.GetUdacityPublicUserDataParsingError }
        guard let last_name = user["last_name"] as? String else { throw Errors.GetUdacityPublicUserDataParsingError }
        guard let first_name = user["first_name"] as? String else { throw Errors.GetUdacityPublicUserDataParsingError }
        
        let loggedInStudent = StudentPublicData(key: key, last_name: last_name, first_name: first_name)
        
        return loggedInStudent
        
    }
    
}





