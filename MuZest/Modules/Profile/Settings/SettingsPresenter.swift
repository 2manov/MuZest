//
//  SettingsPresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

class SettingsPresenter:  SettingsPresenterProtocol {
    
    
    weak var view: SettingsViewProtocol!
    var interactor: SettingsInteractorProtocol!
    var router: SettingsRouterProtocol!
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func configureView() {
    }
    
    
    
}
