//
//  TweetsViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/30/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {

    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            for tweet in tweets {
                print("\(tweet.text)")
            }
        }, failure: { (error: Error) in
            print("Error: \(error.localizedDescription)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
