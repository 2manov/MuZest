//
//  PostTableViewCell.swift
//  MuZest
//
//  Created by Никита Туманов on 21/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var numberOfLikesButton: UIButton!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    
    
    var post: Post! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI()
    {
        self.postImageView.image = post.image
        postCaptionLabel.text = post.caption
        numberOfLikesButton.setTitle("Be the first one to share a comment", for: [])
        timeAgoLabel.text = post.timeAgo
    }
}
