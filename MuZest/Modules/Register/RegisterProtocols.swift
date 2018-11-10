//
//  RegisterProtocols.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation
import UIKit


protocol RegisterViewProtocol: class {
    
    var username: String? { get }
    var password: String? { get }
    var passwordConfirm: String? { get }
    var email: String? { get }
    
    func showAlert(with error: String)
    func performSegue(withIdentifier: String, sender : Any?)
}

protocol RegisterConfiguratorProtocol: class {
    
    func configure(with viewController: RegisterView)
    
}

protocol RegisterRouterProtocol: class {
    
    func performForSegue(with nameSegue : String)
    
}

protocol RegisterInteractorProtocol: class {
    
    func registerAction(with regData: Dictionary<String, String>)
    
}

protocol RegisterPresenterProtocol: class {
    
    var router: RegisterRouterProtocol! { set get }
    
    func configureView()
    func backButtonClicked()
    func regButtonClicked()
    func regSuccess()
    func showAlertToView(with error: String)
    
}
