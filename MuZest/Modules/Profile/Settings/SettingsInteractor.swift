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
    
    func sendDataToDataBase(imageData: Data) {
        
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
    
    }
    
    
    func sendDataToDatabase(photoUrl : String){
        
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
            }
            else {
                print ("user not found")
            }
            
        })
    }
    
    func getUserData() {
        
        if Auth.auth().currentUser != nil {
            ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
                if snapshot.value != nil {
                    let dict = snapshot.value as! Dictionary<String,String>
                    self.userData[snapshot.key] = UserData(
                        username: snapshot.key,
                        real_name : dict["first_name"],
                        about: dict["about"],
                        follows: dict["follows"],
                        profile_photo_url: dict["profile_photo_url"]
                    )
                    DispatchQueue.main.async {
                        self.presenter.updateView(self.userData[snapshot.key]!)
                    }
                }
                else {
                    print ("user not found")
                }
            })
        }
        
    }
}
