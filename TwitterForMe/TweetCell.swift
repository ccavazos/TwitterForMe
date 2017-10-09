//
//  TweetCell.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/30/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate {
    @objc optional func tweetCell(tweetCell: TweetCell, didTapUserProfile tweet: Tweet)
}


class TweetCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var verifiedImageView: UIImageView!
    @IBOutlet var screenNameLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            if let profileUrl = tweet.user?.profileUrl {
                profileImageView.setImageWith(profileUrl)
                profileImageView.layer.cornerRadius = 3
                profileImageView.clipsToBounds = true
            }
            nameLabel.text = tweet.user?.name
            if let isVerified = tweet.user?.verified {
                verifiedImageView.isHidden = !isVerified
           }
            screenNameLabel.text = "@\(tweet.user?.screenName ?? "error")"
            tweetTextLabel.text = tweet.text
            if let time = tweet.timestamp {
                timestampLabel.text = time.timeAgoSinceNow()
            }
            // print(tweet.text!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTap(sender: Any) {
        delegate?.tweetCell?(tweetCell: self, didTapUserProfile: tweet)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
