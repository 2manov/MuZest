//
//  CreatePostViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase
import iTunesSearchAPI

class CreatePostViewController: UIViewController {
    
    var song: SongModel?

    @IBAction func browseButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toBrowse", sender: Any.self)
        
    }
    
    @IBOutlet weak var songImage: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songAuthor: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var browseButton: UIButton!
    @IBOutlet weak var postAboutLabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        browseButton.layer.borderWidth = 1.0
        browseButton.layer.cornerRadius = 2.0
        browseButton.layer.borderColor = browseButton.tintColor.cgColor
        browseButton.layer.masksToBounds = true
        
        postButton.layer.borderWidth = 1.0
        postButton.layer.cornerRadius = 2.0
        postButton.layer.borderColor = postButton.tintColor.cgColor
        postButton.layer.masksToBounds = true
        
        
        updateVC()
    }
    
    private func updateVC(){
        self.songName.text = song?.name
        self.songAuthor.text = song?.artistName
        setArtworkImage()
    }
    
    private func setArtworkImage() {
        self.songImage.image = UIImage(named: "AppIcon")
        guard let safeUrlString = self.song?.artworkUrl, let safeUrl = URL(string: safeUrlString) else {
            return
        }
        
        if let image = SongModel.imagesCache.object(forKey: safeUrlString as NSString) {
            // Image found in cache
            self.songImage.image = image
            return
        }
        
        URLSession.shared.dataTask(with: safeUrl) { (data, response, error) in
            if error != nil {
                log.error("Failed fetching image: \(error.debugDescription)")
                self.songImage.image = nil
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                log.error("Error with HTTPURLResponse or statusCode")
                self.songImage.image = nil
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    SongModel.imagesCache.setObject(image, forKey: safeUrlString as NSString)
                    self.songImage.image = image
                }
            }
            }.resume()
    }
    
    
    @IBAction func postButtonClicked(_ sender: Any) {
        
          let ref = Database.database().reference()
        
        if self.song == nil {
            let alertController = UIAlertController(title: "Error", message: "Please browse some song", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formatter_1 = DateFormatter()
        formatter_1.dateFormat = "HH:mm:ss"
        let today = formatter.string(from: date)
        let time = formatter_1.string(from: date)
        
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        newPostReference.setValue(["username": MyProfile.shared.username!,
                                   "iTunesId": song?.iTunesId,
                                   "songName": song?.name,
                                   "artistName": song?.artistName,
                                   "artworkUrl": song?.artworkUrl,
                                   "iTunesPreviewUrl": song?.iTunesPreviewUrl,
                                   "iTunesUrl": song?.iTunesUrl,
                                   "dt":today,
                                   "time":time,
                                   "post_about":postAboutLabel.text ?? ""], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success")
        })
        
    }
    
}
