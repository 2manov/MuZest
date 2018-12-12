//
//  RegisterInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class RegisterInteractor : RegisterInteractorProtocol {

    
    weak var presenter: RegisterPresenterProtocol!
    var databaseRefer: DatabaseReference!
    var databaseHandle: DatabaseHandle!
    
    
    
    required init(presenter: RegisterPresenterProtocol) {
        self.presenter = presenter
        self.databaseRefer = Database.database().reference()
    }
    
   

    func checkUsername(with username: String) -> Bool {
        
        if username.isEmpty {
            self.presenter.showAlertToView(with: "Username is empty")
            return false
        }

        if !isUsernameCorrect(in: username) {
            self.presenter.showAlertToView(with: "Username is incorrect. Please use only english words, numbers and '_'")
            return false
        }
        
        return true
    }
    
    func isUsernameCorrect(in username: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: "[^a-zA-Z0-9_]")
            let results = regex.matches(in: username, range: NSRange(username.startIndex..., in: username))
            
            let res = results.compactMap {
                Range($0.range, in: username).map { String(username[$0]) }
            }
            return res.isEmpty ? true : false
        }
        catch _ {
            return false
            }
    }
    
    func saveUserInfo(_ user: Firebase.User, withUsername username: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        
        changeRequest?.commitChanges() { (error) in
            
            if let error = error {
                self.presenter.showAlertToView(with: error.localizedDescription)
                return
            }
            self.databaseRefer.child("users").child(username).setValue(["user_id": user.uid,
                                                                        "first_name": "",
                                                                        "last_name": "",
                                                                        "profile_photo_url":"",
                                                                        "about":"",
                                                                        "follows":""])
        }
    }
    
    func registerAction(with regData: Dictionary<String, String>) {
        
        if !self.checkUsername(with: regData["username"]!) {
            return
        }
        
        self.databaseRefer.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.hasChild(regData["username"]!) {
                
                if regData["password"] != regData["passwordConfirm"] {
                    DispatchQueue.main.async {
                        self.presenter.showAlertToView(with: "Please re-type password")
                    }
                } else {
                    Auth.auth().createUser(withEmail: regData["email"]!, password: regData["password"]!){ (authResult, error) in
                        if error == nil {
                            self.saveUserInfo((authResult?.user)!, withUsername: regData["username"]!)
                            self.presenter.regSuccess()
                        }
                        else {
                            DispatchQueue.main.async {
                                self.presenter.showAlertToView(with: (error?.localizedDescription)!)
                            }
                        }
                    }
                }
            } else {
                self.presenter.showAlertToView(with: "Username is already exist")
            }
            
        })
    }
}
