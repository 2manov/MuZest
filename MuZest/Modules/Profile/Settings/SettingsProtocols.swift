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
    
}

protocol SettingsRouterProtocol: class {
    
    
}

protocol SettingsInteractorProtocol: class {
    
}

protocol SettingsPresenterProtocol: class {
    
    var router: SettingsRouterProtocol! { set get }
    func configureView()
    
}

