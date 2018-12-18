//
//  ProfilePresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation

class ProfilePresenter:  ProfilePresenterProtocol {


    weak var view: ProfileViewProtocol!
    var interactor: ProfileInteractorProtocol!
    var router: ProfileRouterProtocol!
    
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        DispatchQueue.main.async {
            self.view.nameLabel.text = MyProfile.shared.username
            self.view.realNameLabel.text = "\(MyProfile.shared.real_name ?? "")"
            self.view.heightForTextView(text:MyProfile.shared.about ?? "")
            self.view.followingLabel.text = "followings: " + String(MyProfile.shared.follow_names?.count ?? 0)
            self.view.postsLabel.text = "posts: " + String(MyProfile.shared.post_ids?.count ?? 0)
            self.view.followersLabel.text = "followers: " + String( MyProfile.shared.follower_names?.count ?? 0)
            if let _ = MyProfile.shared.loadPhotoStatus {
                self.view.setDataToPhoto(with: MyProfile.shared.photo!)
            }
        }
    }
    
    func updateView(_ userData: UserData) {
        
        view.nameLabel.text = userData.username
        view.realNameLabel.text = "\(userData.real_name ?? "")"
        view.heightForTextView(text:userData.about ?? "")
        view.aboutLabel.text = userData.about
        view.followingLabel.text = "followings: \(userData.follows!.split(separator: "\t").count)"
        
        view.spinSpinner(isActive: false)
    }
    
    func updatePhoto (with photo : Data){
        view.setDataToPhoto(with: photo)
    }

}
