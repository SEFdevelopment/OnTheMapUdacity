//
//  AlertControllers.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class AlertControllers {
    
    // MARK: - No internet alert
    func noInternetAlert() -> UIAlertController {
        
        let title = NSLocalizedString("No internet", comment: "")
        let message = NSLocalizedString("There seem to be no internet connection. Please turn on the internet on your device and try again.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    
    // MARK: - Empty user name or password alert
    func emptyUsernameOrPasswordAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Empty fields", comment: "")
        let message = NSLocalizedString("Empty user name or password.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Wrong user name or password alert
    func wrongCredentialsAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Login error", comment: "")
        let message = NSLocalizedString("Wrong user name or password.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    
    // MARK: - Login error alert
    func loginErrorAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Login error", comment: "")
        let message = NSLocalizedString("Could not log in. Please try again.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Login expired alert
    func loginExpiredAlert(completionHandler: () -> ()) -> UIAlertController {
        
        let title = NSLocalizedString("Login expired", comment: "")
        let message = NSLocalizedString("Please authorize again.", comment: "")
        let cancelButtonTitle = NSLocalizedString("OK", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: { action in
            
            completionHandler()
            
        })
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Wrong url alert
    func wrongUrlAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Invalid link", comment: "")
        let message = NSLocalizedString("Please enter a valid internet link.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismass", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Url cannot be opened alert
    func urlCannotBeOpenedAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Invalid link", comment: "")
        let message = NSLocalizedString("This link cannot be opened in browser.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismass", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Getting data from server error alert
    func gettingDataFromServerErrorAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Server error", comment: "")
        let message = NSLocalizedString("We could not communicate with the server. Please try again later.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Getting data from server error alert with completion handler
    func gettingDataFromServerErrorAlertWithHandler(completionHandler: () -> ()) -> UIAlertController {
        
        let title = NSLocalizedString("Server error", comment: "")
        let message = NSLocalizedString("We could not communicate with the server. Please try again later.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: { action in
            
            completionHandler()
            
        })
        
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Empty text fields alert
    func emptyAddressTextViewAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Empty address", comment: "")
        let message = NSLocalizedString("Please enter a location.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
    // MARK: - Geocoding error alert
    func geocodingErrorAlert() -> UIAlertController {
        
        let title = NSLocalizedString("Location not found", comment: "")
        let message = NSLocalizedString("We could not find such a location. Please try to search for an another place.", comment: "")
        let cancelButtonTitle = NSLocalizedString("Dismiss", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    
}




