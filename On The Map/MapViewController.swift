//
//  MapViewController.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit
import MapKit

// MARK: - CLASS
class MapViewController: UIViewController {
    
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Alerts
    lazy var alerts = AlertControllers()
    
    // MARK: - Model
    lazy var students = Students.sharedInstance
    
    // MARK: - Parse client
    var parseClient: ParseClient!
    
    // MARK: - Udacity session
    lazy var udacitySession = UdacitySession.sharedInstance
    
    // MARK: - Internet availability
    var internetAvailable: Bool { return Reachability.isConnectedToNetwork() }
    
    // MARK: - View controller visibility on screen
    var viewControllerVisible = false
    
    // MARK: - Segue identifiers
    let logOutSegueIdentifier = "logOutFromMapScene"
    let enterLocationSegueIdentifier = "MapToEnterLocationSegue"
    
    
    // MARK: - METHODS
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToParseClientNotifications()
        
        if internetAvailable {
            
            parseClient.getStudentLocations()
            
        } else {
            
            showNoInternetAlert()
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewControllerVisible = true
        
        if parseClient.isGettingDataFromNetwork {
            
            showLoadingView()
            
        }
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewControllerVisible = false
        
        hideLoadingView()
        
    }
    
    
    deinit {
        
        unsubscribeFromParseClientNotifications()
        
    }
    
    
    // MARK: - @IBActions
    @IBAction func refreshButtonTapped(sender: UIBarButtonItem) {
        
        guard internetAvailable else { showNoInternetAlert(); return }
        
        showLoadingView()
        
        refreshStudentLocations()
        
    }
    
    @IBAction func addLocationButtonTapped(sender: UIBarButtonItem) {
        
        guard internetAvailable else { showNoInternetAlert(); return }
        
        performSegueWithIdentifier(enterLocationSegueIdentifier, sender: nil)
        
    }
    
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == logOutSegueIdentifier {
            
            parseClient.cancelDataTasks()
            
        }
        
        if segue.identifier == enterLocationSegueIdentifier {
            
            let enterLocationViewController = segue.destinationViewController as? EnterLocationViewController
            enterLocationViewController?.parseClient = parseClient
            
        }
        
    }
    
    
    // MARK: - Map related methods
    func refreshAnnotations() {
        
        var annotations = [MKPointAnnotation]()
        
        for studentInformation in students.list {
            
            let latitude = CLLocationDegrees(studentInformation.latitude)
            let longitude = CLLocationDegrees(studentInformation.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let firstName = studentInformation.firstName
            let lastName = studentInformation.lastName
            let mediaURL = studentInformation.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
            
        }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
    }
    
}


// MARK: - EXTENSIONS

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "studentLocationPin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            
            if let urlString = view.annotation?.subtitle! {
                
                if let url = Validators.validatedURLForString(urlString) {
                    
                    UIApplication.sharedApplication().openURL(url)
                    
                } else {
                    
                    presentViewController(alerts.urlCannotBeOpenedAlert(), animated: true, completion: nil)
                    
                }
                
            }
        }
        
    }
    
}


// MARK: - Parse client listener
extension MapViewController: ParseClientListener {
    
    // MARK: - Notifications
    func subscribeToParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didFinishGettingStudentLocations:", name: Notifications.didFinishGettingStudentLocations.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshStudentLocations", name: Notifications.shouldRefreshStudentLocations.rawValue, object: nil)
        
        
    }
    
    
    func unsubscribeFromParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
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
    
    
    // MARK: - Responding to parse client events
    func didFinishGettingStudentLocations(notification: NSNotification) {
        
        hideLoadingView()
        
        if notification.userInfo == nil {
            
            refreshAnnotations()
            
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
    
    
    func refreshStudentLocations() {
        
        parseClient.refreshStudentLocations()
        
    }
    
    
}


// MARK: - Alerts
extension MapViewController {
    
    func showNoInternetAlert() {
        
        guard viewControllerVisible else { return }
        
        presentViewController(alerts.noInternetAlert(), animated: true, completion: nil)
        
    }
    
    func showGettingDataFromServerErrorAllert() {
        
        guard viewControllerVisible else { return }
        
        presentViewController(alerts.gettingDataFromServerErrorAlert(), animated: true, completion: nil)
        
    }
    
    
    func showLoginExpiredAlert() {
        
        guard viewControllerVisible else { return }
        
        let alertController = alerts.loginExpiredAlert({
            self.performSegueWithIdentifier(self.logOutSegueIdentifier, sender: nil)
        })
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }    
    
}
