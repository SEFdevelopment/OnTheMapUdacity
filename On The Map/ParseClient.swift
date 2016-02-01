//
//  ParseClient.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class ParseClient {
    
    // MARK: - PROPERTIES
    
    // MARK: - Network stack
    lazy var parseURLRequests = ParseURLRequests()
    lazy var parseJSONParsers = ParseJSONParsers()
    lazy var session = NSURLSession.sharedSession()
    lazy var statusCodesChecker = StatusCodesChecker()
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    
    // MARK: - Parse client states
    var isGettingDataFromNetwork = false
    
    // MARK: - Data tasks
    var getStudentLocationsTask: NSURLSessionDataTask!
    var queryStudentLocationTask: NSURLSessionDataTask!
    var updateStudentLocationTask: NSURLSessionDataTask!
    var postStudentLocationTask: NSURLSessionDataTask!
    
    
    // MARK: - METHODS
    
    // MARK: - Get student locations
    func getStudentLocations() {
        
        getStudentLocationsTask = getStudentLocationsDataTask()
        
        showNetworkActivityIndicator()
        
        isGettingDataFromNetwork = true
        
        getStudentLocationsTask.resume()
        
    }
    
    
    func refreshStudentLocations() {
        
        getStudentLocations()
        

    }
    
    
    func cancelDataTasks() {
        
        getStudentLocationsTask?.cancel()
        
        isGettingDataFromNetwork = false
        
    }
    
    
    // MARK: - Post a student location
    func postStudentLocation(studentInformation: StudentInformation) {
        
        postStudentLocationTask = postStudentLocationDataTask(studentInformation)
        
        showNetworkActivityIndicator()
        
        postStudentLocationTask.resume()
        
    }
    
    
    // MARK: - Query a student location
    func queryStudentLocation(uniqueKey: String) {
        
        queryStudentLocationTask = queryStudentLocationDataTask(uniqueKey)
        
        showNetworkActivityIndicator()
        
        queryStudentLocationTask.resume()
        
    }
    
    
    // MARK: - Update a student location
    func updateStudentLocation(studentInformation: StudentInformation) {
        
        updateStudentLocationTask = updateStudentLocationDataTask(studentInformation)
        
        showNetworkActivityIndicator()
        
        updateStudentLocationTask.resume()
        
        
    }
    
    
    // MARK: - Network activity indicator
    func showNetworkActivityIndicator() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    
    func hideNetworkActivityIndicator() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    
}