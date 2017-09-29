//
//  User.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/29/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    
    init(dictionary: NSDictionary) {
        
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        
        tagline = dictionary["description"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
    }
    
}
