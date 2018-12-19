//
//  PostCell.swift
//  MuZest
//
//  Created by Никита Туманов on 22/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postSongNameLabel: UILabel!
    @IBOutlet weak var postSongArtistLabel: UILabel!
    @IBOutlet weak var aboutPost: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    
    var post: Post?
    
    func updateUI(){
        setArtworkImage(url: post?.song.artworkUrl)
        postSongNameLabel.text = post?.song.name
        postSongArtistLabel.text = post?.song.artistName
        aboutPost.text = post?.post_about
        userName.text = post?.username
    }
    
    private func setArtworkImage(url : String?) {
        self.postImage.image = UIImage(named: "AppIcon")
        guard let safeUrlString = url, let safeUrl = URL(string: safeUrlString) else {
            return
        }
        
        if let image = SongModel.imagesCache.object(forKey: safeUrlString as NSString) {
            self.postImage.image = image
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
            if error != nil {
                log.error("Failed fetching image: \(error.debugDescription)")
                self.postImage.image = nil
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                log.error("Error with HTTPURLResponse or statusCode")
                self.postImage.image = nil
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    SongModel.imagesCache.setObject(image, forKey: safeUrlString as NSString)
                    self.postImage.image = image
                }
            }
            }.resume()
    }

}
