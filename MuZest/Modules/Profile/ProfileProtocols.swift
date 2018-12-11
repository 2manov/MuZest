//
//  ProfileProtocols.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//
import Foundation
import UIKit


protocol ProfileConfiguratorProtocol: class {
    
    func configure(with viewController: ProfileView)
    
}

protocol ProfileViewProtocol: class {
    
}

protocol ProfileRouterProtocol: class {
    
    
}

protocol ProfileInteractorProtocol: class {
    
}

protocol ProfilePresenterProtocol: class {
    
    var router: ProfileRouterProtocol! { set get }
    func configureView()
    
}

