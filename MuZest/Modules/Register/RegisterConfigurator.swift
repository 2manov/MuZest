//
//  RegisterConfigurator.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation


class RegisterConfigurator: RegisterConfiguratorProtocol {
    
    func configure(with view: RegisterView) {
        let presenter = RegisterPresenter(view: view)
        let interactor = RegisterInteractor(presenter: presenter)
        let router = RegisterRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
