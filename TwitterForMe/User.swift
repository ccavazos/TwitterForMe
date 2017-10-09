//
//  User.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/29/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import Foundation

class User: NSObject {
    
    var userId: Int?
    var name: String?
    var screenName: String?
    var profileUrl: URL?
    var tagline: String?
    var verified: Bool?
    var followersCount: Int?
    var followingCount: Int?
    var tweetsCount: Int?
    var backgroundUrl: URL?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        userId = dictionary["id"] as? Int
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        followersCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
        
        tagline = dictionary["description"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString.replacingOccurrences(of: "_normal.jpg", with: ".jpg"))
        }
        let backgroundUrlString = dictionary["profile_banner_url"] as? String
        if let backgroundUrlString = backgroundUrlString {
            backgroundUrl = URL(string: backgroundUrlString)
        }
        
        verified = dictionary["verified"] as? Bool
    }
    
    static let userDidLogOutNotification = NSNotification.Name(rawValue: "UserDidLogout")
    static var _currentUser: User?
    
    class var currentUser: User? {
        
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.data(forKey: "currentUserData")
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: []) as Data
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
}
