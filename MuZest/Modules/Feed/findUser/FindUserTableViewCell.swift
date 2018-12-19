//
//  FindUserTableViewCell.swift
//  MuZest
//
//  Created by Denis Borodaenko on 19/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase

class FindUserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var realNameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    var newFollow : String?
    
    let ref = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.borderWidth = 2
        
        followButton.layer.borderWidth = 1.0
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
        
    }


    @IBAction func followButtonClicked(_ sender: Any) {
        
        if followButton.currentTitle == "Unfollow"{
            self.newFollow = MyProfile.shared.follow_names!.filter { $0 != userNameLabel.text!}.joined(separator: "\t")
            followButton.setTitle("Follow", for: .normal)
        } else {
            if MyProfile.shared.follow_names![0] == "" {
                self.newFollow = userNameLabel.text!
            } else {
                self.newFollow = MyProfile.shared.follow_names!.joined(separator: "\t") + "\t" + userNameLabel.text!
            }
            followButton.setTitle("Unfollow", for: .normal)
        }
        MyProfile.shared.follow_names = newFollow!.components(separatedBy: "\t")
        self.ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
            if snapshot.value != nil {
                let postsReference = self.ref.child("users/\(snapshot.key)/follows")
                postsReference.setValue(self.newFollow, withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                })
            } else {
                print ("user not found")
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
