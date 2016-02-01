//
//  UdacityDataTasks.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // STEPS IN COMPLETION HANDLERS FOR UDACITY DATA TASKS
    
    // 1) We may not be on the delegate thread (main thread). Create a helper method to call the delegate on the main thread.
    
    // 2) Check that there is no error and that non-nil data and response came back from server, otherwise tell the delegate that there was an error.
    
    // 3) Check that the http response was successful and parse the JSON which came from the server. If everything is ok update the model, otherwise tell the delegate that there was an error.
    
    // a) If there is a "user not logged-in" error tell about it to the delegate, so that it can show the login screen.
    
    // b) Otherwise tell the delegate that there was a DataTaskCompletionHandler error, so that it can show for example an alert to user and ask to try again.
    
    
    // MARK: - Create an Udacity session data task using email for authentification
    func createUdacitySessionDataTaskWithEmail(email: String, password: String) -> NSURLSessionDataTask {
        
        let request = udacityURLRequests.createUdacitySessionRequestWithEmail(email, password: password)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 1)
            func didGetCreateUdacitySession(withError error: Errors) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideNetworkActivityIndicator()
                    
                    self.delegate?.didCreateUdacitySession(withError: error)
                    
                }
                
            }
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { didGetCreateUdacitySession(withError: Errors.DataTaskCompletionHandlerError); return }
            
            
            // 3)
            do {
                
                let userId = try self.udacityJSONParsers.parseJSONForCreatingASession(data!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideNetworkActivityIndicator()
                    
                    self.udacitySession.userId = userId
                    
                    self.delegate?.didCreateUdacitySession(withError: nil)
                }
                
                
            } catch { didGetCreateUdacitySession(withError: Errors.DataTaskCompletionHandlerError) }
            
        }
        
        return task
    }
    
    // MARK: - Create an Udacity session data task using Facebook token for authentification
    func createUdacitySessionDataTaskWithFacebookToken(token: String) -> NSURLSessionDataTask {
        
        let request = udacityURLRequests.createUdacitySessionRequestWithFacebookToken(token)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 1)
            func didGetCreateUdacitySession(withError error: Errors) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideNetworkActivityIndicator()
                    
                    self.delegate?.didCreateUdacitySession(withError: error)
                    
                }
                
            }
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { didGetCreateUdacitySession(withError: Errors.DataTaskCompletionHandlerError); return }
            
            
            // 3)
            do {
                
                let userId = try self.udacityJSONParsers.parseJSONForCreatingASession(data!)
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideNetworkActivityIndicator()
                    
                    self.udacitySession.userId = userId
                    
                    self.delegate?.didCreateUdacitySession(withError: nil)
                }
                
                
            } catch { didGetCreateUdacitySession(withError: Errors.DataTaskCompletionHandlerError) }
            
        }
        
        return task
    }
    
    
    
    // MARK: - Delete an Udacity session data task
    func deleteUdacitySessionDataTask() -> NSURLSessionDataTask {
        
        let request = udacityURLRequests.deleteUdacitySessionRequest()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // Even if there is an error while performing this data task we can't do much about it.
            // We anyway delete the user and session in the model (a method in Parse Client) and present the login screen.
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.hideNetworkActivityIndicator()
                
            }
            
        }
        
        return task
        
    }
    
    
    // MARK: - Get public user data data task
    func getUdacityPublicUserDataDataTask() -> NSURLSessionDataTask {
        
        let request = udacityURLRequests.getUdacityPublicUserDataRequest(UdacitySession.sharedInstance.userId)
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            // 1)
            func didGetPublicUserData(withError error: Errors) {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.hideNetworkActivityIndicator()
                    
                    self.delegate?.didGetPublicUserData(withError: error)
                    
                }
                
            }
            
            // 2)
            guard (error == nil) && (data != nil) && (response != nil) else { didGetPublicUserData(withError: Errors.DataTaskCompletionHandlerError); return }
            
            
            // 3)
            do {
                
                let successfulResponse = try self.statusCodesChecker.checkStatusCodeForResponse(response!)
                
                if successfulResponse {
                    
                    let loggedInUserPublicData = try self.udacityJSONParsers.parseJSONForGettingPublicUserData(data!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.hideNetworkActivityIndicator()
                        self.students.loggedInUserPublicData = loggedInUserPublicData
                        self.delegate?.didGetPublicUserData(withError: nil)
                        
                    }
                }
                
                // User not logged in error
            } catch Errors.UserNotLoggedInError { didGetPublicUserData(withError: Errors.UserNotLoggedInError)
                
                // All other errors
            } catch { didGetPublicUserData(withError: Errors.DataTaskCompletionHandlerError) }
            
        }
        
        return task
        
    }
    
    
}