//
//  ComposeViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/1/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var tweetCountButton: UIBarButtonItem!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var tweetTextArea: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextArea.delegate = self
        
        if let imageUrl = User.currentUser?.profileUrl {
            profileImageView.setImageWith(imageUrl)
            profileImageView.layer.cornerRadius = 3
            profileImageView.clipsToBounds = true
        }
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = "@\(User.currentUser?.screenName ?? "Error")"
        
        tweetTextArea.becomeFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.characters.count
        let charsLeft = 140 - (newText.characters.count)
        tweetCountButton.title = "\(charsLeft)"
        return numberOfChars <= 140;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonTapped(_ sender: UIBarButtonItem) {
        let status = tweetTextArea.text
        if status?.characters.count == 0 {
            print("You can't tweet empty tweets")
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TwitterClient.sharedInstance?.sendTweet(status: status!, success: {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: Error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            print("Error tweetings: \(error.localizedDescription)")
        })
        
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
