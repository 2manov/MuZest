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
    
    func checkLogin(with login: String) -> Bool {
        
        if login.isEmpty {
            self.presenter.showAlertToView(with: "Username is empty")
            return false
        }

        if !isLoginCorrect(in: login) {
            self.presenter.showAlertToView(with: "Username is incorrect. Please use only english words, numbers and '_'")
            return false
        }
        
        var isUserExist : Bool = false
        
        databaseRefer.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(login){
                isUserExist = true
            }else{
                isUserExist = false
            }
        })
        
        if isUserExist {
            self.presenter.showAlertToView(with: "Username is already used")
            return false
        } else {
            return true
        }
        
    }
    
    func isLoginCorrect(in login: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[^a-zA-Z0-9_]")
            let results = regex.matches(in: login, range: NSRange(login.startIndex..., in: login))
            
            let res = results.compactMap {
                Range($0.range, in: login).map { String(login[$0]) }
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
            self.databaseRefer.child("users").child(username).setValue(["user_id": user.uid])
        }
    }
    
    
    func registerAction(with regData: Dictionary<String, String>) {
        
        if self.checkLogin(with: regData["username"]!) {
            if regData["password"] != regData["passwordConfirm"] {
                self.presenter.showAlertToView(with: "Please re-type password")
            } else {
                Auth.auth().createUser(withEmail: regData["email"]!, password: regData["password"]!){ (authResult, error) in
                    if error == nil {
                        self.saveUserInfo((authResult?.user)!, withUsername: regData["username"]!)
                    }
                    else{
                        self.presenter.showAlertToView(with: (error?.localizedDescription)!)
                    }
                }
            }
        }
        
    
    }
    
}
