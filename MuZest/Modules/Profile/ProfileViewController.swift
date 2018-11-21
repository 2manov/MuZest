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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func logout(_ sender: Any) {
        print(Auth.auth().currentUser as Any)
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        print(Auth.auth().currentUser as Any)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
