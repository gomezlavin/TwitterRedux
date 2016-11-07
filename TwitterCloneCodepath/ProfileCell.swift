//
//  ProfileCell.swift
//  TwitterCloneCodepath
//
//  Created by SGLMR on 06/11/16.
//  Copyright © 2016 Golavs. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userHandleLabel: UILabel!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var profileSegmentedControl: UISegmentedControl!

    var user: User! {
        didSet {
            userImageView.setImageWith((user?.profileUrl!)!)
            userNameLabel.text = user?.name
            userHandleLabel.text = "@\((user?.screenName)!)"
            
            let backgroundImageData = try! Data(contentsOf: (user?.profileBackgroundUrl!)!)
            UIGraphicsBeginImageContext(backgroundImageView.frame.size)
            UIImage(data: backgroundImageData)?.draw(in: backgroundImageView.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            backgroundImageView.backgroundColor = UIColor(patternImage: image)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 5
        userImageView.layer.borderWidth = 3
        userImageView.layer.borderColor = UIColor.white.cgColor
        userImageView.clipsToBounds = true
        locationImageView.image = locationImageView.image!.withRenderingMode(.alwaysTemplate)
        locationImageView.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
