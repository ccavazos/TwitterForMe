//
//  DetailViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/1/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

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
        
    }

    @IBAction func retweetButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        
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
