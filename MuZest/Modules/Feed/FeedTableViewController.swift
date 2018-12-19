//
//  FeedTableViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 22/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase

struct Storyboard {
    static let postCell = "PostCell"
    static let postHeaderCell = "PostHeaderCell"
    static let postHeaderHeight: CGFloat = 57.0
    static let postCellDefaultHeight: CGFloat = 578.0
}

class FeedTableViewController: UITableViewController {

    var posts: Array<Post> = []
    var post_ids : Array<String> = []
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toFind", sender: Any.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadPosts()
        
//        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
//        self.tableView.rowHeight = 300
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        loadPosts()
    }
    
    func loadPosts(){
        let ref = Database.database().reference()
        if MyProfile.shared.follow_names == nil {
            return
        }
            ref.child("posts").observe(.value, with: { snapshot in
                if ( snapshot.value is NSNull ) {
                    print("not found")
                } else {
                    self.posts = []
                    for child in (snapshot.children) {
                        let snap = child as! DataSnapshot
                        let dict = snap.value as! [String: String]
                        if MyProfile.shared.follow_names!.contains(dict["username"]!) {
                            DispatchQueue.main.async {
                                self.posts.append(Post(
                                        username: dict["username"]!,
                                        song : SongModel(
                                            iTunesId: dict["iTunesId"]!,
                                            name: dict["songName"]!,
                                            artistName: dict["artistName"]!,
                                            artworkUrl: dict["artworkUrl"]!,
                                            iTunesPreviewUrl: dict["iTunesPreviewUrl"]!,
                                            iTunesUrl: dict["iTunesUrl"]!),
                                        dt: dict["dt"]!,
                                        time: dict["time"]!,
                                        post_about: dict["post_about"] ?? ""
                                    ))
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        
        
    }
    
}

extension FeedTableViewController
{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as! PostCell
        
        cell.post = self.posts[indexPath.row]
        cell.updateUI()
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
    
    
}
