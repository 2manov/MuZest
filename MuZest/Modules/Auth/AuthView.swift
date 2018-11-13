//
//  AuthViewController.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class AuthView: UIViewController, UITextFieldDelegate, AuthViewProtocol {
    
    var presenter: AuthPresenterProtocol!
    let configurator: AuthConfiguratorProtocol = AuthConfigurator()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    var email: String?
    var password: String?
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    

    @IBAction func regButtonClicked(_ sender: Any) {
        presenter.regButtonClicked()
        
    }
   
    @IBAction func forgotPasswordButtonClicked(_ sender: Any) {
        self.showAlert(with: "To be continued...")
    }
    
    
    @IBAction func authButtonClicked(_ sender: Any) {
        self.email = emailLabel?.text ?? ""
        self.password = passwordLabel?.text ?? ""
        
        presenter.authButtonClicked()

    }
    
    
    func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    

    

}
