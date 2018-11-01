//
//  RegisterView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class RegisterView: UIViewController, RegisterViewProtocol {
    
    var presenter: RegisterPresenterProtocol!
    let configurator: RegisterConfiguratorProtocol = RegisterConfigurator()
    
    var username: String?
    var password: String?
    var passwordConfirm: String?
    var email: String?
    
    @IBOutlet weak var usernameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var passwordConfirmTextField: UITextField?
    @IBOutlet weak var emailTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    @IBAction func regButtonClicked(_ sender: UIButton) {
        self.username = usernameTextField?.text
        self.password = passwordTextField?.text
        self.passwordConfirm = passwordConfirmTextField?.text
        self.email = emailTextField?.text
        
        presenter.regButtonClicked()
    }
    
    func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
