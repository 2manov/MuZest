//
//  SettingsProtocols.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation


protocol SettingsConfiguratorProtocol: class {
    
    func configure(with viewController: SettingsView)
    
}

protocol SettingsViewProtocol: class {
    
    func fillDataUser(_ first_name: String, _ last_name: String, _ about: String)
}

protocol SettingsRouterProtocol: class {
    
    
}

protocol SettingsInteractorProtocol: class {
    func getUserData()
}

protocol SettingsPresenterProtocol: class {
    
    var router: SettingsRouterProtocol! { set get }
    func configureView()
    func updateView(_ with: UserData)
    
}

