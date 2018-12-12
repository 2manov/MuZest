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
    
    var nameLabel: UILabel! {get set}
    var realNameLabel: UILabel! {get set}
    var aboutLabel: UILabel! {get set}
    var followingLabel: UILabel! {get set}
    var followersLabel: UILabel! {get set}
    var postsLabel: UILabel! {get set}
    
    func spinSpinner(isActive status: Bool)
    
}

protocol ProfileRouterProtocol: class {
    
    
}

protocol ProfileInteractorProtocol: class {
    
    func getUserData()
    
}

protocol ProfilePresenterProtocol: class {
    
    var router: ProfileRouterProtocol! { set get }
    func configureView()
    func updateView(_ with: UserData)
    
}

