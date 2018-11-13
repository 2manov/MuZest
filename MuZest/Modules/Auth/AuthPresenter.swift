//
//  AuthPresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class AuthPresenter : AuthPresenterProtocol{
   
    weak var view: AuthViewProtocol!
    var interactor: AuthInteractorProtocol!
    var router: AuthRouterProtocol!
    
    required init(view: AuthViewProtocol) {
        self.view = view
    }
    
    func configureView() {
    }
    
    
    func authButtonClicked() {
//        let authData: [String: String] = ["email": view.email ?? "",
//                                         "password": view.password ?? ""]
//
//        interactor.authAction(with: authData)
        self.authSuccess()
    }

    func regButtonClicked() {
        router.performForSegue(with : "toRegister")
    }
    
    func authSuccess() {
        router.performForSegue(with : "toFeed")
    }
    
    func showAlertToView(with error: String) {
        view.showAlert(with: error)
    }
    

}
