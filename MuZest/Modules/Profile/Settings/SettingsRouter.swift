//
//  SettingsRouter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

class SettingsRouter: SettingsRouterProtocol {
    
    weak var view: SettingsViewProtocol!
    
    required init(view: SettingsView) {
        self.view = view
    }
    
    
}
