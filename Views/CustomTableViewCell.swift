//
//  CustomTableViewCell.swift
//  Fitsmind
//
//  Created by Mamun Ar Rashid on 7/9/17.
//  Copyright © 2017 Fantasy Apps. All rights reserved.
//

import UIKit


class CustomTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}

