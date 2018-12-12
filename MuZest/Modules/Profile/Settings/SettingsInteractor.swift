//
//  SettingsInteractor.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

class SettingsInteractor: SettingsInteractorProtocol {
    
    weak var presenter: SettingsPresenterProtocol!
    
    required init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
    }
}
