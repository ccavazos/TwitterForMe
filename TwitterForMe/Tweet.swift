//
//  Tweet.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/29/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    
    var id: Int = 0
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var retweeted: Bool?
    var favoritesCount: Int = 0
    var user: User?
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id"] as! Int 
        text = dictionary["text"] as? String
        retweeted = dictionary["retweeted"] as? Bool
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString)
        }
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
    }
    
    class func tweetsFromArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
        
    }
}
