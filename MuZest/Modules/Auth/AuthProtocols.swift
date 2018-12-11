//
//  AuthProtocols.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit


protocol AuthConfiguratorProtocol: class {
    
    func configure(with viewController: AuthView)
    
}

protocol AuthViewProtocol: class {
    
    var email: String? { get }
    var password: String? { get }
    
    func showAlert(with error: String)
    func performSegue(withIdentifier: String, sender : Any?)
}

protocol AuthRouterProtocol: class {
    
    func performForSegue(with nameSegue : String)
    
}

protocol AuthInteractorProtocol: class {
    
    func authAction(with: Dictionary<String, String>)
    
}

protocol AuthPresenterProtocol: class {
    
    var router: AuthRouterProtocol! { set get }
    
    func configureView()
    
    func authButtonClicked()
    func authSuccess()
    
    func showAlertToView(with error: String)

    
}


