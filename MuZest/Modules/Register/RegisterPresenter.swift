//
//  RegisterPresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation

class RegisterPresenter : RegisterPresenterProtocol{

    
    
    weak var view: RegisterViewProtocol!
    var interactor: RegisterInteractorProtocol!
    var router: RegisterRouterProtocol!
    
    required init(view: RegisterViewProtocol) {
        self.view = view
    }
    
    func configureView() {
    }
    
    func showAlertToView(with error : String){
        view.showAlert(with: error)
    }
    
    func regButtonClicked() {
        let regData: [String: String] = ["username": view.username ?? "",
                                         "password": view.password ?? "",
                                         "passwordConfirm": view.passwordConfirm ?? "",
                                         "email": view.email ?? ""]
        interactor.registerAction(with : regData)
    }
    
    func regSuccess(){
        view.goBackToAuth()
    }

}
