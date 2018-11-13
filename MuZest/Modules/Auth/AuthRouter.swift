//
//  AuthRouter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 13/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit


class AuthRouter : AuthRouterProtocol {
    
    
    weak var view: AuthViewProtocol!
    
    required init(view: AuthView) {
        self.view = view
    }
    
    func performForSegue(with nameSegue: String) {
        view.performSegue(withIdentifier: nameSegue, sender: (Any).self)
    }
    
}

