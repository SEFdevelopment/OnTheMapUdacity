//
//  ParseDataTasks.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // STEPS IN COMPLETION HANDLERS FOR PARSE DATA TASKS
    
    // 1) We may not be on the main thread. Create a helper method to send notifications on the main thread.
    
    // 2) Check that there is no error and that non-nil data and response came back from server, otherwise send notifications that there was an error.
    
    // 3) Check that the http response was successful and parse the JSON which came from the server. If everything is ok update the model, otherwise send a notification that there was an error.
    
    // a) If there is a "user not logged-in" error notify about it, so that the app can show the login screen.
    
    // b) Otherwise notify that there was a DataTaskCompletionHandler error, so that the app can show for example an alert to user and ask to try again.
    
    // MARK: - Methods
    
    // 1) Helper method
    func notifyAboutError(notification: Notifications, errorString: String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil, userInfo: ["error": errorString])
            
            self.hideNetworkActivityIndicator()
            
            self.isGettingDataFromNetwork = false
            
        }
        
    }
    
    
    // Get student locations data task
    func getStudentLocationsDataTask() -> NSURLSessionDataTask {
        
        let request = parseURLRequests.getStudentLocationsRequest()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { self.notifyAboutError(Notifications.didFinishGettingStudentLocations, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString); return }
            
            
            // 3)
            do {
                
                let successfulResponse = try self.statusCodesChecker.checkStatusCodeForResponse(response!)
                
                if successfulResponse {
                    
                    let studentInformations = try self.parseJSONParsers.parseJSONForGettingStudentLocations(data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.students.list = studentInformations
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.didFinishGettingStudentLocations.rawValue, object: nil, userInfo: nil)
                        
                        self.hideNetworkActivityIndicator()
                        
                        self.isGettingDataFromNetwork = false
                        
                    }
                    
                }
                
                
                // User not logged in error
            } catch Errors.UserNotLoggedInError {
                
                self.notifyAboutError(Notifications.didFinishGettingStudentLocations, errorString: ErrorStrings.userNotLoggedInErrorString)
                return
                
                // All other errors
            } catch {
                
                self.notifyAboutError(Notifications.didFinishGettingStudentLocations, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString)
                return
                
            }
        }
        
        return task
        
    }
    
    
    // Post a student location data task
    func postStudentLocationDataTask(studentInformation: StudentInformation) -> NSURLSessionDataTask {
        
        let request = parseURLRequests.postStudentLocationRequest(studentInformation)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { self.notifyAboutError(Notifications.didFinishPostingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString); return }
            
            
            do {
                
                let successfulResponse = try self.statusCodesChecker.checkStatusCodeForResponse(response!)
                
                if successfulResponse {
                    
                    try self.parseJSONParsers.parseJSONForPostingStudentLocation(data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.didFinishPostingStudentLocation.rawValue, object: nil, userInfo: nil)
                        
                        self.hideNetworkActivityIndicator()
                        
                        
                    }
                    
                }
                
                
                // User not logged in error
            } catch Errors.UserNotLoggedInError {
                
                self.notifyAboutError(Notifications.didFinishPostingStudentLocation, errorString: ErrorStrings.userNotLoggedInErrorString)
                return
                
                // All other errors
            } catch {
                
                self.notifyAboutError(Notifications.didFinishPostingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString)
                return
                
            }
        }
        
        return task
        
    }
    
    
    // Query for a student location data task
    func queryStudentLocationDataTask(uniqueKey: String) -> NSURLSessionDataTask {
        
        let request = parseURLRequests.queryStudentLocationRequest(uniqueKey: uniqueKey)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { self.notifyAboutError(Notifications.didFinishQueryingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString); return }
            
            do {
                
                let successfulResponse = try self.statusCodesChecker.checkStatusCodeForResponse(response!)
                
                if successfulResponse {
                    
                    let studentInformation = try self.parseJSONParsers.parseJSONForQueryingStudentLocation(data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.students.existingStudentLocation = studentInformation
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.didFinishQueryingStudentLocation.rawValue, object: nil, userInfo: nil)
                        
                        self.hideNetworkActivityIndicator()
                        
                        self.isGettingDataFromNetwork = false
                    }
                    
                    
                }
                
                // User not logged in error
            } catch Errors.UserNotLoggedInError {
                
                self.notifyAboutError(Notifications.didFinishQueryingStudentLocation, errorString: ErrorStrings.userNotLoggedInErrorString)
                return
                
                // All other errors
            } catch {
                
                self.notifyAboutError(Notifications.didFinishQueryingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString)
                return
                
            }
        }
        
        return task
        
    }
    
    
    // Update a student location data task
    func updateStudentLocationDataTask(studentInformation: StudentInformation) -> NSURLSessionDataTask {
        
        let request = parseURLRequests.updateStudentLocationRequest(studentInformation: studentInformation)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { self.notifyAboutError(Notifications.didFinishUpdatingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString); return }
            
            do {
                
                let successfulResponse = try self.statusCodesChecker.checkStatusCodeForResponse(response!)
                
                if successfulResponse {
                    
                    try self.parseJSONParsers.parseJSONForUpdatingStudentLocation(data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.didFinishUpdatingStudentLocation.rawValue, object: nil, userInfo: nil)
                        
                        self.hideNetworkActivityIndicator()
                        
                        
                    }
                    
                }
                
                // User not logged in error
            } catch Errors.UserNotLoggedInError {
                
                self.notifyAboutError(Notifications.didFinishUpdatingStudentLocation, errorString: ErrorStrings.userNotLoggedInErrorString)
                return
                
                // All other errors
            } catch {
                
                self.notifyAboutError(Notifications.didFinishUpdatingStudentLocation, errorString: ErrorStrings.dataTaskCompletionHandlerErrorString)
                return
                
            }
        }
        
        return task
        
    }
    
}