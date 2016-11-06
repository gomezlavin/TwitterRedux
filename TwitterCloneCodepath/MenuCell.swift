//
//  MenuCell.swift
//  TwitterCloneCodepath
//
//  Created by SGLMR on 05/11/16.
//  Copyright © 2016 Golavs. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var optionImageView: UIImageView!
    @IBOutlet weak var optionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
