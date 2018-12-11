//
//  ProfileInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//


class ProfileInteractor: ProfileInteractorProtocol {

    weak var presenter: ProfilePresenterProtocol!
    
    required init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
}
