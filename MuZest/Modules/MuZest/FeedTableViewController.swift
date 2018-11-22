//
//  FeedTableViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 22/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController
{
    var posts: [Post]?
    
    struct Storyboard {
        static let postCell = "PostCell"
        static let postHeaderCell = "PostHeaderCell"
        static let postHeaderHeight: CGFloat = 57.0
        static let postCellDefaultHeight: CGFloat = 578.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchPosts()
        
        tableView.estimatedRowHeight = Storyboard.postCellDefaultHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = UIColor.clear
        self.tableView.rowHeight = 578
    }
    
    func fetchPosts()
    {
        self.posts = Post.fetchPosts()
        self.tableView.reloadData()
    }
}

extension FeedTableViewController
{
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let posts = posts {
            return posts.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = posts {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postCell, for: indexPath) as! PostCell
        
        cell.post = self.posts?[indexPath.section]
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.postHeaderCell) as! PostHeaderCell
        
        cell.post = self.posts?[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.postHeaderHeight
    }
    
    
    
}
