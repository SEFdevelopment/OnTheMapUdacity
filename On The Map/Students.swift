//
//  Students.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class Students {
    
    // MARK: - PROPERTIES
    
    // MARK: - Shared instance
    static let sharedInstance = Students()
    
    // MARK: - Model
    var list = [StudentInformation]()
    
    // MARK: - Logged in user
    var loggedInUserPublicData: StudentPublicData?
    var existingStudentLocation: StudentInformation?
    
    
}
