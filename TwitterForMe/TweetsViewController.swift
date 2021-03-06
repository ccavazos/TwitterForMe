//
//  TweetsViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/30/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate, TweetCellDelegate {

    @IBOutlet var tableView: UITableView!
    
    var tweets: [Tweet]!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 106
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching new tweets...")
        refreshControl.addTarget(self, action: #selector(refreshTimeline), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)

        fetchTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        TwitterClient.sharedInstance?.logout()
    }
    
    // MARK: - Fetch Tweets
    
    func fetchTweets() {
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.finishFetch()
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
            // TODO: We should probably display a better error bgere
            self.finishFetch()
        })
    }
    
    func finishFetch() {
        refreshControl.endRefreshing()
        MBProgressHUD.hide(for: self.view, animated: true)
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
        cell.delegate = self
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
    
    // MARK: - TweetCell Delegate
    
    func tweetCell(tweetCell: TweetCell, didTapUserProfile tweet: Tweet) {
        self.performSegue(withIdentifier: "profileSegue", sender: tweetCell)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
        } else if segue.identifier == "profileSegue" {
            let tweetCell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: tweetCell)
            let detailVC = segue.destination as! ProfileViewController
            detailVC.userId = (tweets[indexPath!.row].user?.userId)!
        }
    }

}
