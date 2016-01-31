//
//  ErrorStrings.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

struct ErrorStrings {
    
    // The userInfo dictionary from postNotifications method does not accept swift enums, so we will use strings to notify about errors
    static let dataTaskCompletionHandlerErrorString = "DataTaskCompletionHandlerError"
    static let userNotLoggedInErrorString = "UserNotLoggedInError"
    
}