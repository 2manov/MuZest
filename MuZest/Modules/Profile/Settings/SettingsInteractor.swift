//
//  SettingsInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Firebase

class SettingsInteractor: SettingsInteractorProtocol {
    
    weak var presenter: SettingsPresenterProtocol!
    
    var userData = [String : UserData]()
    
    let ref = Database.database().reference()
    
    required init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func checkStorage(){
        if Auth.auth().currentUser != nil {
            ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
                if snapshot.value != nil {
                    let dict = snapshot.value as! Dictionary<String,String>
                    
                    if dict["profile_photo_url"] != nil {
                        let stReference = Storage.storage().reference(forURL: dict["profile_photo_url"]!)
                        stReference.delete { error in
                            if let error = error {
                                print(error)
                            } else {
                                print ("deletig success")
                            }
                        }
                    }
                }
                    
            })
        } else {
            print ("user not found")
        }
    }
    
    
    func sendDataToDataBase(imageData: Data) {
        
        let photoIdString = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("user_data").child(photoIdString)
        
        checkStorage() //Удаление старой фотографии профиля, если имеется
        
        storageRef.putData(imageData, metadata : nil) { (metadata, error) in
            if (error != nil) {
                print (error as Any)
                return
            }
            storageRef.downloadURL { (url, error) in
                guard url != nil else {
                    return
                }
                self.sendPhotoUrlToDatabase(photoUrl: (url?.absoluteString)!)
            }
        }
    
    }
    
    
    func sendPhotoUrlToDatabase(photoUrl : String){
        
        let ref = Database.database().reference()
        
        ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
            if snapshot.value != nil {
                let postsReference = ref.child("users/\(snapshot.key)/profile_photo_url")
                postsReference.setValue(photoUrl, withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
//                    print("Success")
                })
            } else {
                print ("user not found")
            }
            
        })
    }
}
