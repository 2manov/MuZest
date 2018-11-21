//
//  RegisterView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class RegisterView: UIViewController, UITextFieldDelegate, RegisterViewProtocol {
    
    var presenter: RegisterPresenterProtocol!
    let configurator: RegisterConfiguratorProtocol = RegisterConfigurator()
    
    var username: String?
    var password: String?
    var passwordConfirm: String?
    var email: String?
    
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var usernameTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    @IBOutlet weak var passwordConfirmTextField: UITextField?
    @IBOutlet weak var emailTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        self.usernameTextField?.delegate = self
        self.passwordTextField?.delegate = self
        self.passwordConfirmTextField?.delegate = self
        self.emailTextField?.delegate = self
    }
    
    @IBAction func regButtonClicked(_ sender: UIButton) {
        self.username = usernameTextField?.text
        self.password = passwordTextField?.text
        self.passwordConfirm = passwordConfirmTextField?.text
        self.email = emailTextField?.text
        
        presenter.regButtonClicked()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        presenter.backButtonClicked()
    }
    
    
    func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == usernameTextField) {
            usernameTextField?.resignFirstResponder()
            passwordTextField?.becomeFirstResponder()
        }
        else if (textField == passwordTextField) {
            passwordTextField?.resignFirstResponder()
            passwordConfirmTextField?.becomeFirstResponder()
        }
        else if (textField == passwordConfirmTextField) {
            passwordConfirmTextField?.resignFirstResponder()
            emailTextField?.becomeFirstResponder()
        }
        else if (textField == emailTextField) {
            emailTextField?.resignFirstResponder()
        }
        
        return(true)
    }

}



