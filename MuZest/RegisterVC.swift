//
//  RegisterVC.swift
//  MuZest
//
//  Created by Никита Туманов on 18/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class RegisterVC: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
        ref = Database.database().reference()
    }
    
    private func showAlert (_ error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        if password.text != passwordConfirm.text {
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: email.text!, password: password.text!){ (authResult, error) in
                if error == nil {
                    
                    self.saveUserInfo((authResult?.user)!, withUsername: self.username.text!)
                    
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
                else{
                    self.showAlert((error?.localizedDescription)!)
                }
            }
        }
    }
    
    func saveUserInfo(_ user: Firebase.User, withUsername username: String) {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        // Commit profile changes to server
        changeRequest?.commitChanges() { (error) in
            
            if let error = error {
                self.showAlert(error.localizedDescription)
                return
            }
            
            // [START basic_write]
            self.ref.child("users").child(user.uid).setValue(["username": username])
            // [END basic_write]
            self.performSegue(withIdentifier: "toHome", sender: nil)
        }
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
