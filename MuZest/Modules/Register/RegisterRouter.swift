//
//  RegisterRouter.swift
//  MuZest
//
//  Created by Denis Borodaenko on 28/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit


class RegisterRouter : RegisterRouterProtocol {
    
    
    weak var view: RegisterViewProtocol!
    
    required init(view: RegisterView) {
        self.view = view
    }
    
    func performForSegue(with nameSegue: String) {
        
        view.performSegue(withIdentifier: nameSegue, sender : nil)
        
    }
}
