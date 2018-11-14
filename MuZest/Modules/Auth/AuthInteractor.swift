//
//  AuthInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class AuthInteractor : AuthInteractorProtocol {
    
    weak var presenter: AuthPresenterProtocol!
    var databaseRefer: DatabaseReference!
    var databaseHandle: DatabaseHandle!

    required init(presenter: AuthPresenterProtocol) {
        self.presenter = presenter
        self.databaseRefer = Database.database().reference()
    }
    
    
    func authAction(with authData: Dictionary<String, String>) {
        
        if let email = authData["email"], let pass = authData["password"] {
            
            Auth.auth().signIn(withEmail: email, password: pass) { (user, error) in
                if let error = error {
                    self.presenter.showAlertToView(with: error.localizedDescription)
                    return
                } else {
                    self.presenter.authSuccess()
                }
            }
        } else {
            presenter.showAlertToView(with: "email/password can't be empty")
        }
    }
}
