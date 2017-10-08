//
//  MenuCell.swift
//  TwitterForMe
//
//  Created by Cesar Cavazos on 10/7/17.
//  Copyright © 2017 Cesar Cavazos. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet var menuImageView: UIImageView!
    @IBOutlet var menuLabel: UILabel!
    @IBOutlet var isSelectedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
