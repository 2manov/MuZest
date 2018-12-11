//
//  ProfileViewController.swift
//  MuZest
//
//  Created by Никита Туманов on 21/11/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase

class ProfileView: UIViewController, ProfileViewProtocol {
    
    var presenter: ProfilePresenterProtocol!
    let configurator: ProfileConfiguratorProtocol = ProfileConfigurator()
    
    
    @IBOutlet weak var realScrollView: UIScrollView!
    
    @IBOutlet weak var scrollView: UIView!
    
    @IBOutlet weak var aboutLabel: UILabel!
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        aboutLabel.numberOfLines = 0
        aboutLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutLabel.font = font
        aboutLabel.text = text
        
        aboutLabel.sizeToFit()
        return aboutLabel.frame.height
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        let font = UIFont(name: "Helvetica", size: 20.0)
        let s = "This is just a load of text"
        let height_of_text = heightForView(text:s, font: font!, width: 100.0)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: realScrollView.frame.size.height + height_of_text - 50)
        
        view.addConstraints([heightConstraint])
    }
    
    
    
    
    
    @IBAction func logout(_ sender: Any) {
        
        if Auth.auth().currentUser != nil{
            try! Auth.auth().signOut()
            
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthController") as UIViewController
            self.present(viewController, animated: true, completion: nil)

            
            }
        }
}
