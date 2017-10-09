//
//  ProfileViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/7/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate {

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetCountLabel: UILabel!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    var userId: Int = (User.currentUser?.userId)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 106
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching new tweets...")
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
        
        fetchUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    // MARK: - Fetch User Profile
    
    func fetchUser() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        TwitterClient.sharedInstance?.userProfile(userId: userId, success: { (user: User?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let user = user {
                // Populate user
                if let imageUrl = user.profileUrl {
                    self.profileImageView.setImageWith(imageUrl)
                    self.profileImageView.layer.borderWidth = 2
                    self.profileImageView.layer.borderColor = UIColor.white.cgColor
                    self.profileImageView.layer.cornerRadius = 3
                    self.profileImageView.clipsToBounds = true
                }
                if let backgroundUrl = user.backgroundUrl {
                    self.backgroundImageView.setImageWith(backgroundUrl)
                    self.backgroundImageView.clipsToBounds = true
                }
                self.userLabel.text = user.name
                self.screenNameLabel.text = "@\(user.screenName ?? "Error")"
                self.tweetCountLabel.text = String(user.tweetsCount!)
                self.followersCountLabel.text = String(user.followersCount!)
                self.followingCountLabel.text = String(user.followingCount!)
                
            } else {
                // Display an error
            }
        }, failure: { (error: Error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            // Display an error
        })
        
        fetchTweets()
    }
    
    // MARK: - Fetch Tweets
    
    func fetchTweets() {
        TwitterClient.sharedInstance?.userTweets(userId: userId, success: { (tweets: [Tweet]) in
            print(tweets)
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }, failure: { (error: Error) in
            // Display an error
            print(error.localizedDescription)
            self.refreshControl.endRefreshing()
        })
    }
    
    // MARK: - Pull Down to refresh
    
    func refreshTimeline() {
        fetchTweets()
    }
    
    // MARK: - TableView Delegate/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets == nil {
            return 0
        }
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - ComposeViewController Delegate
    
    func composeViewController(composeViewController: ComposeViewController, didSendUpdate tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let navigationController = segue.destination as! UINavigationController
            let composeVC = navigationController.topViewController as! ComposeViewController
            composeVC.delegate = self
        } else if segue.identifier == "detailSegue" {
            let tweetCell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: tweetCell)
            let detailVC = segue.destination as! DetailViewController
            detailVC.tweet = tweets[indexPath!.row]
        }
    }

}
