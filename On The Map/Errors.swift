//
//  Errors.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

// ERROR HANDLING LOGIC IN THIS APP:
// 1) Network unavailable - tell the user about no internet connection and ask him to try again.
// 2) Parsing errors - propagate them further
// 3) Parsing errors, nil data and error in dataTask's completion handler - tell the user that there was an error in fetching/updating the data and ask him to try again later.

// (In a production app it might make sense for the app to retry itself and after a certain number of unsuccesful retrials to inform the user).

enum Errors: ErrorType {
    
    // Udacity JSON parsing errors
    case CreatingUdacitySessionParsingError
    case DeletingUdacitySessionParsingError
    case GetUdacityPublicUserDataParsingError
    
    // Parse JSON parsing errors
    case GetStudentLocationsParsingError
    case PostStudentLocationParsingError
    case UpdatingStudentLocationParsingError
    // JSON parsing errors are mostly for debugging
    
    // Data tasks completion handlers errors
    case DataTaskCompletionHandlerError
    
    // Http response status codes errors
    case InvalidStatusCodeError
    case UserNotLoggedInError
    case UnsuccessStatusCodeError
    
    
}