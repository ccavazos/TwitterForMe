//
//  MenuViewController.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/7/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    private var profileViewController: UIViewController!
    private var homeTimelineViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    var menuItems: [NSMutableDictionary] = [[
            "icon" : "Home",
            "title" : "Home",
            "isSelected" : true
        ],[
            "icon" : "Mention",
            "title" : "Mentions",
            "isSelected" : false
        ],[
            "icon" : "Profile",
            "title" : "Profile",
            "isSelected" : false
        ]]
    var currentItem = 0
    var mainViewController: MainViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        homeTimelineViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "TweetsNavigationController")
        
        viewControllers.append(homeTimelineViewController)
        viewControllers.append(mentionsViewController)
        viewControllers.append(profileViewController)
        
        mainViewController.contentViewController = homeTimelineViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Delegate/DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        let menuItem = menuItems[indexPath.row]
        
        cell.menuImageView.image = UIImage(named: menuItem["icon"] as! String)
        cell.menuLabel.text = menuItem["title"] as? String
        
        if let isSelected = menuItem["isSelected"] as? Bool {
            if isSelected {
                cell.isSelectedLabel.isHidden = false
            } else {
                cell.isSelectedLabel.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldIndexPath = IndexPath(row: currentItem, section: 0)
        let oldMenuItem = tableView.cellForRow(at: oldIndexPath) as! MenuCell
        oldMenuItem.isSelectedLabel.isHidden = true
        
        let selectedItem = tableView.cellForRow(at: indexPath) as! MenuCell
        selectedItem.isSelectedLabel.isHidden = false
        
        mainViewController.contentViewController = viewControllers[indexPath.row]
        
        currentItem = indexPath.row
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
