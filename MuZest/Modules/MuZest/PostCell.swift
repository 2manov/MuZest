//
//  PostCell.swift
//  MuZest
//
//  Created by Никита Туманов on 22/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var numberOfLikeButtons: UIButton!
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
        numberOfLikeButtons.setTitle("Be the first one to share a comment", for: [])
        timeAgoLabel.text = post.timeAgo
    }

}
