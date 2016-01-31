//
//  StudentInformation.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2015 Andrei Sadovnicov. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: - PROPERTIES
    var objectId: String?
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
    
    // MARK: - INITIALIZERS
    init(studentInfoDictionary: NSDictionary) {
        
        objectId = studentInfoDictionary["objectId"] as? String
        uniqueKey = studentInfoDictionary["uniqueKey"] as! String
        firstName = studentInfoDictionary["firstName"] as! String
        lastName = studentInfoDictionary["lastName"] as! String
        mapString = studentInfoDictionary["mapString"] as! String
        mediaURL = studentInfoDictionary["mediaURL"] as! String
        latitude = studentInfoDictionary["latitude"] as! Double
        longitude = studentInfoDictionary["longitude"] as! Double
        
        
    }
    
    
}
