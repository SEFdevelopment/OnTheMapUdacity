//
//  ParseClientListener.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

@objc protocol ParseClientListener {
    
    
    // MARK: - Subscribe to parse notifications
    func subscribeToParseClientNotifications()
    
    func unsubscribeFromParseClientNotifications()
    
    
    // MARK: - Methods responding to parse notifications
    optional func didFinishGettingStudentLocations()
    
    optional func refreshStudentLocations()
    
    optional func didFinishQueryingStudentLocation()
    
    optional func didFinishUpdatingStudentLocation()
    
    
}