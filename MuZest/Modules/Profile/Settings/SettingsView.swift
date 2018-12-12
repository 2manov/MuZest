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
        
        
        
        //Тап по фото
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        profileImageLabel.addGestureRecognizer(tapGesture)
        profileImageLabel.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto(){ //Обработка тапа по фото
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func doneButtonClicked(_ sender: Any) { //Сохранение данных о прфоиле
        
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            presenter.sendPhotoToDatabase(with: imageData)
        }
            
        else {
            showAlert(with: "File cannot be empty")
        }
        
    }
    
    func showAlert(with error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
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


