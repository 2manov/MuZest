//
//  ProfileViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 21/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

//    let databaseRefer = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    @IBAction func logout(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            try! Auth.auth().signOut()
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthController") as UIViewController
            self.present(viewController, animated: true, completion: nil)

            
            }
        }
}
