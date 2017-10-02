//
//  DetailViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/1/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetContentLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
    }
    
    func loadTweet() {
        if let profileUrl = tweet.user?.profileUrl {
            profileImageView.setImageWith(profileUrl)
            profileImageView.layer.cornerRadius = 3
            profileImageView.clipsToBounds = true
        }
        nameLabel.text = tweet.user?.name
        screenNameLabel.text = "@\(tweet.user?.screenName ?? "error")"
        tweetContentLabel.text = tweet.text
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        timestampLabel.text = dateFormatter.string(from: tweet.timestamp!)
        retweetCountLabel.text = "\(tweet.retweetCount)"
        favoriteCountLabel.text = "\(tweet.favoritesCount)"
        print(tweet.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Not implemented :(", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if tweet.retweeted == true {
            TwitterClient.sharedInstance?.unretweet(statusId: tweet.id, success: { (tweet: Tweet) in
                let alertController = UIAlertController(title: "Unretweet success!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
                self.tweet.retweeted = false
                self.tweet.retweetCount = self.tweet.retweetCount - 1
                self.loadTweet()
            }, failure: { (error: Error) in
                let alertController = UIAlertController(title: "Error", message: "There was an error attempting to perform the action. Try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            TwitterClient.sharedInstance?.retweet(statusId: tweet.id, success: { (tweet: Tweet) in
                let alertController = UIAlertController(title: "Retweet success!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
                
                self.tweet.retweeted = true
                self.tweet.retweetCount = self.tweet.retweetCount + 1
                self.loadTweet()
                
            }, failure: { (error: Error) in
                let alertController = UIAlertController(title: "Error", message: "There was an error attempting to perform the action. Try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if tweet.favorited == true {
            TwitterClient.sharedInstance?.unlike(statusId: tweet.id, success: { (tweet: Tweet) in
                let alertController = UIAlertController(title: "Unlike success!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
                
                self.tweet.favorited = false
                self.tweet.favoritesCount = self.tweet.favoritesCount - 1
                self.loadTweet()
                
            }, failure: { (error: Error) in
                let alertController = UIAlertController(title: "Error", message: "There was an error attempting to perform the action. Try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
            })
        } else {
            TwitterClient.sharedInstance?.like(statusId: tweet.id, success: { (tweet: Tweet) in
                let alertController = UIAlertController(title: "Like success!", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
                
                self.tweet.favorited = true
                self.tweet.favoritesCount = self.tweet.favoritesCount + 1
                self.loadTweet()
                
            }, failure: { (error: Error) in
                let alertController = UIAlertController(title: "Error", message: "There was an error attempting to perform the action. Try again later", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                })
                alertController.addAction(okAction)
                MBProgressHUD.hide(for: self.view, animated: true)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
