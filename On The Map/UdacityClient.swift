//
//  UdacityClient.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class UdacityClient {
    
    // MARK: - PROPERTIES
    
    // MARK: - Network stack
    lazy var udacityURLRequests = UdacityURLRequests()
    lazy var udacityJSONParsers = UdacityJSONParsers()
    lazy var session = NSURLSession.sharedSession()
    lazy var statusCodesChecker = StatusCodesChecker()
    
    // MARK: - Authorization
    lazy var udacitySession = UdacitySession.sharedInstance
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    
    // MARK: - Delegate
    weak var delegate: UdacityClientDelegate?
    
    // MARK: - Data tasks
    var createUdacitySessionWithEmailTask: NSURLSessionDataTask!
    var createUdacitySessionWithFacebookTokenTask: NSURLSessionDataTask!
    var deleteUdacitySessionTask: NSURLSessionDataTask!
    var getUdacityPublicUserDataTask: NSURLSessionDataTask!
    
    
    // MARK: - METHODS
    
    // MARK: - Create an Udacity session
    func createUdacitySessionWithEmail(email: String, password: String) {
        
        createUdacitySessionWithEmailTask = createUdacitySessionDataTaskWithEmail(email, password: password)
        
        showNetworkActivityIndicator()
        
        createUdacitySessionWithEmailTask.resume()
        
    }
    
    
    func createUdacitySessionWithFacebookToken(token: String) {
        
        createUdacitySessionWithFacebookTokenTask = createUdacitySessionDataTaskWithFacebookToken(token)
        
        showNetworkActivityIndicator()
        
        createUdacitySessionWithFacebookTokenTask.resume()
        
    }
    
    
    // MARK: - Delete an Udacity session
    func deleteUdacitySession() {
        
        deleteUdacitySessionTask = deleteUdacitySessionDataTask()
        
        showNetworkActivityIndicator()
        
        udacitySession.userId = ""
        students.loggedInUserPublicData = nil
        students.existingStudentLocation = nil
        
        deleteUdacitySessionTask.resume()
        
    }
    
    
    // MARK: - Get Udacity public user data
    func getUdacityPublicUserData() {
        
        showNetworkActivityIndicator()
        
        getUdacityPublicUserDataTask = getUdacityPublicUserDataDataTask()
        
        getUdacityPublicUserDataTask.resume()
        
        
    }
    
    
    
    // MARK: - Network activity indicator
    func showNetworkActivityIndicator() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    
    func hideNetworkActivityIndicator() {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    
}