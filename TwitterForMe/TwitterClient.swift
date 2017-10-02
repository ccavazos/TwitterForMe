//
//  TwitterClient.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/30/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "6PmXhrEUZ97ncmfKg1HAOFnn1", consumerSecret: "xSkcffLl05CrhGREwTTkOe7wb2zS3vA8Qj9JjYeWh8nKZXhA0G")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterForMe://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            if let token = requestToken?.token {
                print("We got a token")
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("token not found")
            }
        }, failure: { (error: Error?) in
            print("Error: \(String(describing: error?.localizedDescription))")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: User.userDidLogOutNotification, object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            // Get the current account of the user
            self.currentAccount(success: { (user: User) in
                // Persiste the user
                User.currentUser = user
                // We are all set
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            print("Hello")
            print(dictionaries)
            let tweets = Tweet.tweetsFromArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! NSDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func sendTweet(status: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let status: NSDictionary = [
            "status": status
        ]
        post("1.1/statuses/update.json", parameters: status, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            success(newTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(statusId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/statuses/retweet/\(statusId).json"
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            success(newTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(statusId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let urlString = "1.1/statuses/unretweet/\(statusId).json"
        post(urlString, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            success(newTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func like(statusId: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        let status: NSDictionary = [
            "status": statusId
        ]
        post("1.1/favorites/create.json", parameters: status, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            let newTweet = Tweet(dictionary: response as! NSDictionary)
            success(newTweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
}
