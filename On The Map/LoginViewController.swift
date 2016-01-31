//
//  LoginViewController.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

// MARK: - CLASS
class LoginViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Alerts
    lazy var alerts = AlertControllers()
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    
    // MARK: - Udacity sessions
    lazy var udacityClient = UdacityClient()
    lazy var udacitySession = UdacitySession.sharedInstance
    
    // MARK: - Parse client
    lazy var parseClient = ParseClient()
    
    // MARK: - Internet availability
    var internetAvailable: Bool { return Reachability.isConnectedToNetwork() }
    
    // MARK: - Signup link
    let udacitySignUpUrlString = "https://www.udacity.com/account/auth#!/signup"
    
    // MARK: - Segue identifier
    let successfulLoginSegue = "SuccessfulLoginSegue"
    
    
    // MARK: - METHODS
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        udacityClient.delegate = self
        
    }
    
    // MARK: - @IBActions
    @IBAction func LoginButtonTapped(sender: UIButton) {
        
        view.endEditing(true)
        
        if let username = userNameTextField.text, password = passwordTextField.text {
            
            if username.isEmpty || password.isEmpty {
                
                showEmptyUsernameOrPasswordAlert()
                
            } else {
                
                if internetAvailable {
                    
                    showLoadingView()
                    
                    udacityClient.createUdacitySession(username: username, password: password)
                    
                } else {
                    
                    showNoInternetAlert()
                    
                }
                
            }
        }
    }
    
    
    
    @IBAction func SignUpButtonTapped(sender: UIButton) {
        
        if let url = Validators.validatedURLForString(udacitySignUpUrlString) {
            
            UIApplication.sharedApplication().openURL(url)
            
        }
        
    }
    
    
    
    @IBAction func FacebookButtonTapped(sender: UIButton) {
        
        showLoadingView()
        
    }
    
    
    // MARK: - Show/hide loading view
    func showLoadingView() {
        
        loadingView.hidden = false
        activityIndicator.startAnimating()
        
    }
    
    
    func hideLoadingView() {
        
        activityIndicator.stopAnimating()
        loadingView.hidden = true
        
    }
    
    
    // MARK: - Unwind segues
    @IBAction func logOut(segue: UIStoryboardSegue) {
        
        parseClient.cancelDataTasks()
        
        udacityClient.deleteUdacitySession()
        
        
    }
    
    // MARK: - Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == successfulLoginSegue {
            
            // Injecting the parse client into view controllers
            let tabBarController = segue.destinationViewController as? UITabBarController
            let navigationControllerToMapView = tabBarController?.viewControllers?[0] as? UINavigationController
            let navigationControllerToListView = tabBarController?.viewControllers?[1] as? UINavigationController
            
            let mapViewController = navigationControllerToMapView?.topViewController as? MapViewController
            let listViewController = navigationControllerToListView?.topViewController as? ListViewController
            
            mapViewController?.parseClient = parseClient
            listViewController?.parseClient = parseClient
            
        }
        
    }
    
}


// MARK: - EXTENSIONS

// MARK: - UITextField delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            
            passwordTextField.becomeFirstResponder()
            
        } else if textField == passwordTextField {
            
            textField.resignFirstResponder()
            
            
        }
        
        return true
        
    }
    
}

// MARK: - Udacity client delegate
extension LoginViewController: UdacityClientDelegate {
    
    // In order to login the following conditions should be fulfilled:
    // a) A successful session should be created.
    // b) Logged-in user's public data should be successfully fetched from Udacity.
    
    func didCreateUdacitySession(withError error: Errors?) {
        
        guard error == nil else {
            
            loadingView.hidden = true
            
            presentViewController(alerts.wrongCredentialsAlert(), animated: true, completion: nil)
            
            return
            
        }
        
        udacityClient.getUdacityPublicUserData()
        
    }
    
    
    func didGetPublicUserData(withError error: Errors?) {
        
        guard error == nil else {
            
            loadingView.hidden = true
            
            presentViewController(alerts.loginErrorAlert(), animated: true, completion: nil)
            
            return
            
        }
        
        hideLoadingView()
        
        performSegueWithIdentifier(successfulLoginSegue, sender: self)
        
    }
    
}


// MARK: - Alerts
extension LoginViewController {
    
    func showEmptyUsernameOrPasswordAlert() {
        
        presentViewController(alerts.emptyUsernameOrPasswordAlert(), animated: true, completion: nil)
        
    }
    
    
    func showWrongUserNameOrPasswordAlert() {
        
        presentViewController(alerts.wrongCredentialsAlert(), animated: true, completion: nil)
        
    }
    
    
    func showNoInternetAlert() {
        
        presentViewController(alerts.noInternetAlert(), animated: true, completion: nil)
        
    }
    
}
