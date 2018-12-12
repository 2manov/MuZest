//
//  SettingsView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import Firebase
import MobileCoreServices

class SettingsView: UIViewController, SettingsViewProtocol {
    
    var imageProfile : UIImage!
    
    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var firstNameTextLabel: UITextField!
    @IBOutlet weak var lastNameTextLabel: UITextField!
    @IBOutlet weak var aboutTextField: UITextView!
    
     var selectedImage: UIImage?
    
    var presenter: SettingsPresenterProtocol!
    let configurator: SettingsConfiguratorProtocol = SettingsConfigurator()
    
    
    func didDisualSettings() {
        
        profileImageLabel.layer.cornerRadius = profileImageLabel.frame.height / 2
        profileImageLabel.layer.masksToBounds = true
        profileImageLabel.layer.borderColor = UIColor.lightGray.cgColor
        profileImageLabel.layer.borderWidth = 1.5
        
        aboutTextField.layer.borderColor = UIColor.lightGray.cgColor
        aboutTextField.layer.borderWidth = 1
    }
    
    
    func fillDataUser(_ first_name: String, _ last_name: String, _ about: String){
        self.firstNameTextLabel.text = first_name
        self.lastNameTextLabel.text = last_name
        self.aboutTextField.text = about
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        didDisualSettings()
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        profileImageLabel.addGestureRecognizer(tapGesture)
        profileImageLabel.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func doneButtonClicked(_ sender: Any) {
        
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            let photoIdString = NSUUID().uuidString

            let storageRef = Storage.storage().reference().child("user_data").child(photoIdString)
            
            storageRef.putData(imageData, metadata : nil) {
                (metadata, error) in
                
                if (error != nil) {
                    print (error as Any)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard url != nil else {
                        return
                    }
                    self.sendDataToDatabase(photoUrl: (url?.absoluteString)!)
                }
            }
        } else {
            print("File cannot be empty")
        }
    }
    
    func sendDataToDatabase(photoUrl : String){
        
        let ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
            if snapshot.value != nil {
                let postsReference = ref.child("users").child(snapshot.key)
                let newPostId = postsReference.childByAutoId().key
                postsReference.setValue(["profile_photo_url": photoUrl], withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    print("Success")
                })
            }
            else {
                print ("user not found")
            }
        
            }
        )
    }
}

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


