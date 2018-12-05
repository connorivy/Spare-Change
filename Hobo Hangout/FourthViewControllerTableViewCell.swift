//
//  FourthViewControllerTableViewCell.swift
//  Hobo Hangout
//
//  Created by Connor Ivy on 8/26/18.
//  Copyright © 2018 Connor Ivy. All rights reserved.
//

import UIKit

class FourthViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var story: UILabel!
    @IBOutlet weak var goToProfile: UIButton!
    
    var index:Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
