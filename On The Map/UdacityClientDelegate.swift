//
//  UdacityClientDelegate.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import Foundation

protocol UdacityClientDelegate: class {
    
    func didCreateUdacitySession(withError error: Errors?)
    
    func didGetPublicUserData(withError error: Errors?)
    
}