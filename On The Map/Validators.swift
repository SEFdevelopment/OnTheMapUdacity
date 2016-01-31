//
//  Validators.swift
//  On The Map
//
//  Created by Andrei Sadovnicov on 31/01/16.
//  Copyright © 2016 Andrei Sadovnicov. All rights reserved.
//

import UIKit

class Validators {
    
    class func validatedURLForString(urlString: String) -> NSURL? {
        
        // 1. Check if the string can be converted to an NSURL
        guard let url = NSURL(string: urlString) else { return nil }
        
        
        // 2. Validate the url using a regular expression (NSURL is bad at properly validating urls). Regular expression pattern taken from: http://stackoverflow.com/questions/30997169/regular-expression-to-get-url-in-string-swift-with-capitalized-symbols
        
        let pattern = "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)"
        
        guard let regularExpression = try? NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive) else { return nil }
        
        let numberOfMatches = regularExpression.numberOfMatchesInString(urlString, options: [], range: NSMakeRange(0, urlString.characters.count))
        
        guard numberOfMatches == 1 else { return nil }
        
        
        // 3. Check whether the url can be opened by UIApplication.sharedApplication()
        guard UIApplication.sharedApplication().canOpenURL(url) else { return nil }
        
        return url
        
    }
    
    
}