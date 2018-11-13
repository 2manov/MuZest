//
//  AuthConfigurator.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//


import Foundation


class AuthConfigurator: AuthConfiguratorProtocol {
    
    func configure(with view: AuthView) {
        let presenter = AuthPresenter(view: view)
        let interactor = AuthInteractor(presenter: presenter)
        let router = AuthRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }

}
