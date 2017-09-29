//
//  LoginViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 9/29/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let twitterClient = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "6PmXhrEUZ97ncmfKg1HAOFnn1", consumerSecret: "xSkcffLl05CrhGREwTTkOe7wb2zS3vA8Qj9JjYeWh8nKZXhA0G")
        
        twitterClient?.deauthorize()
        twitterClient?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterForMe://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            if let token = requestToken?.token {
                print("We got a token = https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("token not found")
            }
            
        }, failure: { (error: Error?) in
            print("Error: \(String(describing: error?.localizedDescription))")
        })
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
