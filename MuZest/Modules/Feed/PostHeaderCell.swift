//
//  PostHeaderCell.swift
//  MuZest
//
//  Created by Никита Туманов on 22/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class PostHeaderCell: UITableViewCell
{

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var imageUrl : String?
    
    
    func updateUI()
    {
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        setArtworkImage(url: imageUrl)
    }
    
    private func setArtworkImage(url : String?) {
        self.profileImageView.image = UIImage(named: "AppIcon")
        guard let safeUrlString = url, let safeUrl = URL(string: safeUrlString) else {
            return
        }
        
        if let image = SongModel.imagesCache.object(forKey: safeUrlString as NSString) {
            self.profileImageView.image = image
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
            if error != nil {
                log.error("Failed fetching image: \(error.debugDescription)")
                self.profileImageView.image = nil
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                log.error("Error with HTTPURLResponse or statusCode")
                self.profileImageView.image = nil
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    SongModel.imagesCache.setObject(image, forKey: safeUrlString as NSString)
                    self.profileImageView.image = image
                }
            }
            }.resume()
    }
    
}
