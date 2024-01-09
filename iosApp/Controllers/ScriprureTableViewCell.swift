//
//  ScriprureTableViewCell.swift
//  iOSApp
//
//  Created by Vladimir Rybant on 08.01.2024.
//  Copyright © 2024 Vladimir Rybant. All rights reserved.
//

import UIKit

class ScriprureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
