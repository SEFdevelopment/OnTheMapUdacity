//
//  ListViewController.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import UIKit

// MARK: - CLASS
class ListViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    
    // MARK: - @IBOutlets
    @IBOutlet var loadingView: UIView!
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
    let logOutSegueIdentifier = "logOutFromListScene"
    let enterLocationSegueIdentifier = "ListToEnterLocationSegue"
    
    
    // MARK: - METHODS
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subscribeToParseClientNotifications()
        
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
    
    
    // MARK: - Loading view
    
    // Interface Builder does not allow adding views on top of entier table view in UITableViewControllers, so we do it programmatically
    
    func addLoadingView() {
        
        loadingView.frame.size = tableView.frame.size
        
        tableView.scrollEnabled = false
        
        tableView.addSubview(loadingView)
        
        activityIndicator.startAnimating()
        
    }
    
    
    func removeLoadingView() {
        
        activityIndicator.stopAnimating()
        
        loadingView.removeFromSuperview()
        
        tableView.scrollEnabled = true
        
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == logOutSegueIdentifier {
            
            viewControllerVisible = false
            
            parseClient.cancelDataTasks()
            
        }
        
        if segue.identifier == enterLocationSegueIdentifier {
            
            let enterLocationViewController = segue.destinationViewController as? EnterLocationViewController
            enterLocationViewController?.parseClient = parseClient
            
        }
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if students.list.isEmpty {
            
            return 1
            
        } else {
            
            return students.list.count
            
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentInfoCell", forIndexPath: indexPath)
        
        if students.list.isEmpty {
            
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            
        } else {
            
            cell.textLabel?.text = students.list[indexPath.row].firstName + " " + students.list[indexPath.row].lastName
            cell.detailTextLabel?.text = students.list[indexPath.row].mediaURL
            cell.imageView?.image = UIImage(named: "Pin")
            
            
            
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if students.list.count > 0 {
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            let urlString = students.list[indexPath.row].mediaURL
            
            if let url = Validators.validatedURLForString(urlString) {
                
                UIApplication.sharedApplication().openURL(url)
                
            } else {
                
                presentViewController(alerts.urlCannotBeOpenedAlert(), animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
}


// MARK: - EXTENSIONS

// MARK: - Parse client listener
extension ListViewController: ParseClientListener {
    
    // MARK: - Notifications
    func subscribeToParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ListViewController.didFinishGettingStudentLocations(_:)), name: Notifications.didFinishGettingStudentLocations.rawValue, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ParseClientListener.refreshStudentLocations), name: Notifications.shouldRefreshStudentLocations.rawValue, object: nil)
        
        
    }
    
    
    func unsubscribeFromParseClientNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
    }
    
    
    // MARK: - Show/hide loading view
    func showLoadingView() {
        
        addLoadingView()
        
    }
    
    
    func hideLoadingView() {
        
        removeLoadingView()
        
    }
    
    // MARK: - Responding to parse client events
    func didFinishGettingStudentLocations(notification: NSNotification) {
        
        hideLoadingView()
        
        if notification.userInfo == nil {
            
            tableView.reloadData()
            
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
extension ListViewController {
    
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
