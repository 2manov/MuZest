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
    
    func fillDataUser(_ real_name: String, _ about: String)
    func showAlert(title: String?, message: String?)
}

protocol SettingsRouterProtocol: class {
    
    
}

protocol SettingsInteractorProtocol: class {
    
    func sendDataToDataBase(imageData: Data)
    func updataDataInProfile(field: String, data: String)
}

protocol SettingsPresenterProtocol: class {
    
    var router: SettingsRouterProtocol! { set get }
    
    func configureView()
    func updateView(_ with: UserData)
    func sendPhotoToDatabase(with imageData : Data)
    func updateProfileInfo(field: String,with data: String)
    
}

