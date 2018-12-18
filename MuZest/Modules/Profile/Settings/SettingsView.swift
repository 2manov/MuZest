//
//  SettingsView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class SettingsView: UIViewController, SettingsViewProtocol {
    
    var imageProfile : UIImage!
    
    @IBOutlet weak var profileImageLabel: UIImageView!
    

    @IBOutlet weak var newView: UIView!
    
    @IBOutlet weak var realNameTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    
    var photo : UIImage?
    var realName : String?
    var about : String?
    
     var selectedImage: UIImage?
    
    var presenter: SettingsPresenterProtocol!
    let configurator: SettingsConfiguratorProtocol = SettingsConfigurator()
    
    
    func didDisualSettings() {
        
        profileImageLabel.layer.cornerRadius = profileImageLabel.frame.height / 2 //скругление
        profileImageLabel.layer.masksToBounds = true
        profileImageLabel.layer.borderColor = UIColor.lightGray.cgColor
        profileImageLabel.layer.borderWidth = 1.5 //обводка
        
        aboutTextField.layer.borderColor = UIColor.lightGray.cgColor
        aboutTextField.layer.borderWidth = 1
        
        realNameTextField.text = realName
        aboutTextField.text = about
        profileImageLabel.image = photo
    }
    
    
    func fillDataUser(_ real_name: String, _ about: String){
        self.realNameTextField.text = real_name
        self.aboutTextField.text = about
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        didDisualSettings()
        self.hideKeyboardWhenTappedAround() 
        //Тап по фото
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        profileImageLabel.addGestureRecognizer(tapGesture)
        profileImageLabel.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/1.2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleSelectPhoto(){ //Обработка тапа по фото
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func doneButtonClicked(_ sender: Any) { //Сохранение данных о прфоиле
        
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            presenter.sendPhotoToDatabase(with: imageData)
            MyProfile.shared.photo = imageData
        }
        if (realNameTextField.text! != realName){
            presenter.updateProfileInfo(field: "real_name",with: realNameTextField.text!)
            MyProfile.shared.real_name = realNameTextField.text!
        }
        if (aboutTextField.text! != about){
            presenter.updateProfileInfo(field: "about", with: aboutTextField.text!)
            MyProfile.shared.about = aboutTextField.text!
        }
        showAlert(title: "Success", message: nil)
    }
    
    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
// Открытие галереи
extension SettingsView: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image =  info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = image
            profileImageLabel.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

