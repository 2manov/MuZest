//
//  SettingsPresenter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation

class SettingsPresenter:  SettingsPresenterProtocol {
    
    
    weak var view: SettingsViewProtocol!
    var interactor: SettingsInteractorProtocol!
    var router: SettingsRouterProtocol!
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
    func configureView() {
    }
    
    func updateView(_ userData: UserData) {
        view.fillDataUser(userData.real_name ?? "", userData.about ?? "")
    }
    
    func sendPhotoToDatabase(with imageData : Data) {
        interactor.sendDataToDataBase(imageData: imageData)
    }
    
    
}
