//
//  ProfileInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import Firebase


class ProfileInteractor: ProfileInteractorProtocol {
    
    var userData = [String : UserData]()
    
    let ref = Database.database().reference()

    weak var presenter: ProfilePresenterProtocol!
    
    required init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func getUserData(){
        
        if Auth.auth().currentUser != nil {
            ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
                if snapshot.value != nil {
                    let dict = snapshot.value as! Dictionary<String,String>
                    self.userData[snapshot.key] = UserData(
                        username: snapshot.key,
                        real_name : dict["real_name"],
                        about: dict["about"],
                        follows: dict["follows"],
                        profile_photo_url: dict["profile_photo_url"]
                    )
                    
                    if dict["profile_photo_url"] != nil {
                        let gsReference = Storage.storage().reference(forURL: dict["profile_photo_url"]!)
                        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                DispatchQueue.main.async {
                                    self.presenter.updatePhoto(with: data!)
                                }
                            }
                        }
                    }
                    
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
