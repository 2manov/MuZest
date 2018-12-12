//
//  SettingsView.swift
//  MuZest
//
//  Created by Denis Borodaenko on 12/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase

class SettingsView: UIViewController, SettingsViewProtocol {
    
    var imageProfile : UIImage!
    @IBOutlet weak var profileImageLabel: UIImageView!
    
    var presenter: SettingsPresenterProtocol!
    let configurator: SettingsConfiguratorProtocol = SettingsConfigurator()

    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        
        profileImageLabel.image = imageProfile
    }
    
}
