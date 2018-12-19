//
//  FindUserTableViewCell.swift
//  MuZest
//
//  Created by Denis Borodaenko on 19/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class FindUserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var realNameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.borderWidth = 2
    }

    @IBAction func followButtonClicked(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
