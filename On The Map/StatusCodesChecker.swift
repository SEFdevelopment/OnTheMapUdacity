//
//  StatusCodesChecker.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

class StatusCodesChecker {
    
    // CASES:
    
    // 1) INVALID HTTP STATUS CODE: throw error
    
    // 2) USER NOT LOGGED OR SESSION EXPIRED: throw error (later the delegate will get the notification to unwind to the login screen)
    // Corresponding codes: 401 (Unauthorized), 403 (Forbidden), 407 (Proxy authentification required), 440 (Login timeout).
    
    // 3) SUCCESS: If it is a status code between 200 and 299
    
    func checkStatusCodeForResponse(response: NSURLResponse) throws -> Bool {
        
        guard let httpResponse = response as? NSHTTPURLResponse else { throw Errors.InvalidStatusCodeError }
        
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
            
        case 200...299:
            return true
            
        case 401, 403, 407, 440:
            throw Errors.UserNotLoggedInError
            
        default:
            throw Errors.UnsuccessStatusCodeError
            
        }
        
    }
    
}