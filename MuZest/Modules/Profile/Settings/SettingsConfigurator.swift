//
//  SettingsConfigurator.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

class SettingsConfigurator: SettingsConfiguratorProtocol{
    
    
    func configure(with viewController: SettingsView) {
        
        let presenter = SettingsPresenter(view: viewController)
        let interactor = SettingsInteractor(presenter: presenter)
        let router = SettingsRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
    
}
