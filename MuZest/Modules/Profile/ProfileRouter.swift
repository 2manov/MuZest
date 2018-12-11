//
//  ProfileRouter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 11/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit

class ProfileRouter: ProfileRouterProtocol {

    weak var view: ProfileViewProtocol!
    
    required init(view: ProfileView) {
        self.view = view
    }


}
