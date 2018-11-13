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
        
        if (authData["email"] == "") {
            presenter.showAlertToView(with: "Email is empty!")
            return
        }
        
        if (authData["password"] == "") {
            presenter.showAlertToView(with: "Password is empty!")
            return
        }

        
        
        
    }


}
