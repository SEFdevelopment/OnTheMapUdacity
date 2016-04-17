//
//  PostViewController.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit
import MapKit

class PostViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: RoundBorderButton!
    @IBOutlet weak var enterUrlTextField: UITextField!
    
    // MARK: - Strings
    let enterALinkToShareString = NSLocalizedString("Enter a Link to Share Here", comment: "")
    
    // MARK: - Alerts
    lazy var alerts = AlertControllers()
    
    // MARK: - Geocoding
    var placemark: CLPlacemark!
    
    // MARK: - Parse client
    var parseClient: ParseClient!
    
    // MARK: - Internet availability
    var internetAvailable: Bool { return Reachability.isConnectedToNetwork() }
    
    // MARK: - Udacity session
    lazy var udacitySession = UdacitySession.sharedInstance
    
    // MARK: - Segue identifiers
    let logOutSegueIdentifier = "logOutFromPostScene"
    
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    var addressString: String!
    
    
    // MARK: - METHODS
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let existingStudentLocation = students.existingStudentLocation {
            
            enterUrlTextField.text = existingStudentLocation.mediaURL
            
        } else {
            
            enterUrlTextField.text = enterALinkToShareString
            
        }
        
        
        let mkPlacemark = MKPlacemark(placemark: placemark)
        mapView.addAnnotation(mkPlacemark)
        mapView.showAnnotations([mkPlacemark], animated: true)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToParseClientNotifications()
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromParseClientNotifications()
        
    }
    
    
    
    // MARK: - @IBActions
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        enterUrlTextField.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func submitButtonTapped(sender: UIButton) {
        
        guard internetAvailable else { showNoInternetAlert(); return }
        
        if let urlString = enterUrlTextField.text, _ = Validators.validatedURLForString(urlString) {
            
            showLoadingView()
            
            let coordinate = placemark.location!.coordinate
            
            if var existingStudentLocation = students.existingStudentLocation {
                
                // Update an existing student location
                existingStudentLocation.mediaURL = urlString
                existingStudentLocation.mapString = addressString
                
                existingStudentLocation.latitude = coordinate.latitude
                existingStudentLocation.longitude = coordinate.longitude
                
                parseClient.updateStudentLocation(existingStudentLocation)
                
            } else {
                
                // Post a new student location
                
                if let studentPublicData = students.loggedInUserPublicData {
                    
                    var studentInfoDictionary = [String: AnyObject]()
                    
                    studentInfoDictionary["objectId"] = nil
                    studentInfoDictionary["uniqueKey"] = studentPublicData.key
                    studentInfoDictionary["firstName"] = studentPublicData.first_name
                    studentInfoDictionary["lastName"] = studentPublicData.last_name
                    studentInfoDictionary["mapString"] = addressString
                    studentInfoDictionary["mediaURL"] = urlString
                    studentInfoDictionary["latitude"] = coordinate.latitude
                    studentInfoDictionary["longitude"] = coordinate.longitude
                    
                    let studentInformation = StudentInformation(studentInfoDictionary: studentInfoDictionary)
                    
                    parseClient.postStudentLocation(studentInformation)
                    
                    
                }
                
            }
            
        } else {
            
            presentViewController(alerts.wrongUrlAlert(), animated: true, completion: nil)
            
        }
        
    }
    
}

// MARK: - EXTENSIONS

// MARK: - UITextField delegate
extension PostViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == enterALinkToShareString {
            
            textField.text = "http://"
            
        }
        
    }
    
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField.text == "" || textField.text == "http://" {
            
            textField.text = enterALinkToShareString
            
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
}


// MARK: - Parse client listener
extension PostViewController: ParseClientListener {
    
    // MARK: - Notifications
    func subscribeToParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostViewController.dismissPostScene(_:)), name: Notifications.didFinishUpdatingStudentLocation.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PostViewController.dismissPostScene(_:)), name: Notifications.didFinishPostingStudentLocation.rawValue, object: nil)
        
    }
    
    
    func unsubscribeFromParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    // MARK: - Show/hide loading view
    func showLoadingView() {
        
        loadingView.hidden = false
        activityIndicator.startAnimating()
        submitButton.enabled = false
        
    }
    
    
    func hideLoadingView() {
        
        activityIndicator.stopAnimating()
        loadingView.hidden = true
        submitButton.enabled = true
    }
    
    // MARK: - Responding to parse client events
    func dismissPostScene(notification: NSNotification) {
        
        hideLoadingView()
        
        if notification.userInfo == nil {
            
            NSNotificationCenter.defaultCenter().postNotificationName(Notifications.shouldRefreshStudentLocations.rawValue, object: nil)
            
            let presentingViewControllerFromTabBar = presentingViewController?.presentingViewController
            
            presentingViewControllerFromTabBar?.dismissViewControllerAnimated(true, completion: nil)
            
        } else {
            
            let errorString = notification.userInfo!["error"] as! String
            
            switch errorString {
                
            case ErrorStrings.userNotLoggedInErrorString:
                
                showLoginExpiredAlert()
                
            default:
                
                showGettingDataFromServerErrorAllert()
                
            }
            
        }
        
    }
    
}


// MARK: - Alerts
extension PostViewController {
    
    func showNoInternetAlert() {
        
        presentViewController(alerts.noInternetAlert(), animated: true, completion: nil)
        
    }
    
    
    func showGettingDataFromServerErrorAllert() {
        
        presentViewController(alerts.gettingDataFromServerErrorAlert(), animated: true, completion: nil)
    }
    
    
    func showLoginExpiredAlert() {
        
        let alertController = alerts.loginExpiredAlert({
            self.performSegueWithIdentifier(self.logOutSegueIdentifier, sender: nil)
        })
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
}


