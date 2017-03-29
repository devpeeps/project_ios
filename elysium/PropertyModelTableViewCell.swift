//
//  PropertyModelTableViewCell.swift
//  elysium
//
//  Created by Joshua Eleazar Bosinos on 26/01/2016.
//  Copyright © 2016 UnionBank. All rights reserved.
//

import UIKit

class PropertyModelTableViewCell: UITableViewCell {

    
    @IBOutlet var lblFirstRow: UILabel!
    @IBOutlet var lblSecondRow: UILabel!
    @IBOutlet var lblThirdRow: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
