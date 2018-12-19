//
//  FindUserTableView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 19/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Foundation
import Firebase

struct cellData {
    var userName : String?
    var realName : String?
    var followers : String?
    var photoData : Data?
}


class FindUserTableView: UIViewController,UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    var dictUsers = [String : cellData]()
    var correctUsers = [String : cellData]()
    
    let ref = Database.database().reference()
    
    var userNames : Array<String> = []
    var correctUserNames : Array<String> = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FindUserTableViewCell
        
        
        if !(correctUserNames.isEmpty){
            if (correctUsers[correctUserNames[indexPath.row]] != nil){
                cell.userNameLabel.text = correctUserNames[indexPath.row]
                cell.realNameLabel.text = correctUsers[correctUserNames[indexPath.row]]!.realName ?? ""
                cell.followersLabel.text = correctUsers[correctUserNames[indexPath.row]]!.followers ?? ""
                if let photoData =  correctUsers[correctUserNames[indexPath.row]]!.photoData{
                    cell.profileImage.image = UIImage(data: photoData)
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return correctUsers.count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){

        correctUsers = dictUsers.filter {$0.key.lowercased().contains(searchText.lowercased())}
        correctUserNames = Array(correctUsers.keys)
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        fillArrayOfNames()
        setUpSearchBar()
        
        tableView.dataSource = self
        tableView.delegate = self
        

    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
    }
    
    private func fillArrayOfNames() {
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.value != nil {
                let dict = snapshot.value as! Dictionary<String,Any>
                DispatchQueue.main.async {
                    self.userNames = Array(dict.keys)
                    self.correctUserNames = Array(dict.keys)
                    self.getDataOfUsers(with : self.userNames)
                }
            }
        })
    }
    
    private func getDataOfUsers(with userNamesToFind : Array<String>) {
        for el in userNamesToFind {
            ref.child("users").child(el).observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.value != nil {
                let dict = snapshot.value as! Dictionary<String,String>
                    if dict["profile_photo_url"] != "" && dict["profile_photo_url"] != nil  {
                        let gsReference = Storage.storage().reference(forURL: dict["profile_photo_url"]!)
                        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                DispatchQueue.main.async {
                                    
                                    self.dictUsers[el] = cellData(userName: el,
                                                                  realName: dict["real_name"],
                                                                  followers: " ",
                                                                  photoData: data!
                                                                  )

//                                    self.correctUsers[el] = self.dictUsers[el]
                                    self.tableView.reloadData()
                                }
                            }
                        }
                        } else {
                        DispatchQueue.main.async {
                            self.dictUsers[el] = cellData(userName: el,
                                                          realName: dict["real_name"],
                                                          followers: " ",
                                                          photoData: nil
                            )
                            
//                            self.correctUsers[el] = self.dictUsers[el]
                            self.tableView.reloadData()
                        }
                    }

            } else {
                print ("profile can't fill")
            }
        })
        
        }
    }
}
