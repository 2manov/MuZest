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
    }
    


}
