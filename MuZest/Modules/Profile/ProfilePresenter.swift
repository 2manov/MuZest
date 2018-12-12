//
//  ProfilePresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

class ProfilePresenter:  ProfilePresenterProtocol {


    weak var view: ProfileViewProtocol!
    var interactor: ProfileInteractorProtocol!
    var router: ProfileRouterProtocol!
    
    required init(view: ProfileViewProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.spinSpinner(isActive: true)
        interactor.getUserData()
        
    }
    

    func updateView(_ userData: UserData) {
        
        view.nameLabel.text = userData.username
        view.realNameLabel.text = "\(userData.first_name!) \(userData.last_name!)"
        view.aboutLabel.text = userData.about
        view.followingLabel.text = "followings: \(userData.follows!.split(separator: "\t").count)"
        
        view.spinSpinner(isActive: false)
        
    }

}
