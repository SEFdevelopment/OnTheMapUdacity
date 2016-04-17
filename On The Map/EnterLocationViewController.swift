//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit
import MapKit

class EnterLocationViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    @IBOutlet weak var findOnMapButton: RoundBorderButton!
    
    // MARK: - Loading status
    enum LoadingStatus {
        
        case queryingExistingLocation
        case geocoding
        
    }
    
    // MARK: - Strings
    let queryingExistingLocationStatusString = NSLocalizedString("Getting your previously submitted location...", comment: "")
    let geocodingStatusString = NSLocalizedString("Searching on the map...", comment: "")
    let enterYourLocationString = NSLocalizedString("You haven't posted a location yet. Enter Your Location Here", comment: "")
    
    // MARK: - Alerts
    lazy var alerts = AlertControllers()
    
    // MARK: - Parse client
    var parseClient: ParseClient!
    
    // MARK: - Internet availability
    var internetAvailable: Bool { return Reachability.isConnectedToNetwork() }
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    
    // MARK: - Udacity session
    lazy var udacitySession = UdacitySession.sharedInstance
    
    // MARK: - Geocoding
    lazy var geocoder = CLGeocoder()
    var placemark: CLPlacemark!
    
    // MARK: - Segue identifiers
    let logOutSegueIdentifier = "logOutFromEnterLocationScene"
    let enterPostSceneSegueIdentifier = "EnterLocationToPostSegue"
    
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToParseClientNotifications()
        
        guard internetAvailable else { showNoInternetAlert(); return }
        
        if let uniqueKey = students.loggedInUserPublicData?.key {
            
            parseClient.queryStudentLocation(uniqueKey)
            
        }
        
        textView.text = ""
        
        showLoadingView(loadingStatus: .queryingExistingLocation)
        
    }
    
    
    deinit {
        
        unsubscribeFromParseClientNotifications()
        
    }
    
    
    // MARK: - @IBActions
    @IBAction func cancelButtonTapped(sender: UIButton) {
        
        textView.resignFirstResponder()
        
        geocoder.cancelGeocode()
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func findOnTheMapButtonTapped(sender: UIButton) {
        
        guard internetAvailable else { showNoInternetAlert(); return }
        
        let addressString = textView.text
        
        if !addressString.isEmpty && addressString != enterYourLocationString {
            
            showLoadingView(loadingStatus: .geocoding)
            
            geocode()
            
        } else {
            
            let alertController = alerts.emptyAddressTextViewAlert
            
            presentViewController(alertController(), animated: true, completion: nil)
            
        }
        
    }
    
    
    
    // MARK: - Geocoding
    func geocode() {
        
        let addressString = textView.text
        
        geocoder.geocodeAddressString(addressString, completionHandler: { placemarks, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.hideLoadingView()
                
            }
            
            if error != nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    let alertController = self.alerts.geocodingErrorAlert
                    
                    self.presentViewController(alertController(), animated: true, completion: nil)
                    
                }
                
                return
                
            }
            
            guard let placemarks = placemarks else { return }
            
            self.placemark = placemarks[0]
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.performSegueWithIdentifier(self.enterPostSceneSegueIdentifier, sender: nil)
                
            }
            
        })
        
        
    }
    
    
    // MARK: - Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == enterPostSceneSegueIdentifier {
            
            let postViewController = segue.destinationViewController as? PostViewController
            
            postViewController?.parseClient = parseClient
            postViewController?.placemark = placemark
            postViewController?.addressString = textView.text
            
            
        }
        
    }
    
    // MARK: - Show/hide loading view
    func showLoadingView(loadingStatus loadingStatus: LoadingStatus) {
        
        switch loadingStatus {
            
        case .queryingExistingLocation:
            loadingStatusLabel.text = queryingExistingLocationStatusString
            
        case .geocoding:
            loadingStatusLabel.text = geocodingStatusString
            
        }
        
        loadingView.hidden = false
        activityIndicator.startAnimating()
        findOnMapButton.enabled = false
        
    }
    
    
    func hideLoadingView() {
        
        activityIndicator.stopAnimating()
        loadingView.hidden = true
        findOnMapButton.enabled = true
        
    }
    
    
}

// MARK: - EXTENSIONS

// MARK: - UITextView delegate
extension EnterLocationViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if textView.text == enterYourLocationString {
            
            textView.text = ""
            
        }
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            
            textView.resignFirstResponder()
            
            return false
            
        }
        
        return true
    }
    
}


// MARK: - Parse client listener
extension EnterLocationViewController: ParseClientListener {
    
    // MARK: - Notifications
    func subscribeToParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EnterLocationViewController.didFinishQueryingStudentLocation(_:)), name: Notifications.didFinishQueryingStudentLocation.rawValue, object: nil)
        
    }
    
    
    func unsubscribeFromParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    // MARK: - Responding to parse client events
    func didFinishQueryingStudentLocation(notification: NSNotification) {
        
        hideLoadingView()
        
        if notification.userInfo == nil {
            
            if let existingLocationString = students.existingStudentLocation?.mapString {
                
                textView.text = existingLocationString
                
            } else {
                
                textView.text = enterYourLocationString
                
            }
            
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
extension EnterLocationViewController {
    
    func showNoInternetAlert() {
        
        presentViewController(alerts.noInternetAlert(), animated: true, completion: nil)
        
    }
    
    func showGettingDataFromServerErrorAllert() {
        
        let alertController = alerts.gettingDataFromServerErrorAlertWithHandler({
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func showLoginExpiredAlert() {
        
        let alertController = alerts.loginExpiredAlert({
            self.performSegueWithIdentifier(self.logOutSegueIdentifier, sender: nil)
        })
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }    
    
}

