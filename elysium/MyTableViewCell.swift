//
//  MyTableViewCell.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 30/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    
    @IBOutlet var txtLabel1: UILabel!
    @IBOutlet var txtLabel2: UILabel!
    @IBOutlet var txtLabel3: UILabel!
    @IBOutlet var txtRightLabel1: UILabel!
    @IBOutlet var txtRightLabel2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
