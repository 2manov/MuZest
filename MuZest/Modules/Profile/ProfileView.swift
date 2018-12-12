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
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
        
        guard let myVC = storyboard?.instantiateViewController(withIdentifier: "SettingsView") else {
            return
        }
        navigationController?.pushViewController(myVC, animated: true)
        
    }
    
    func heightForTextView(text:String, font:String = "Helvetica") -> CGFloat{
        aboutLabel.numberOfLines = 0
        aboutLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        aboutLabel.font = UIFont(name: font, size: 14.0)
        aboutLabel.text = text
        
        aboutLabel.sizeToFit()
        return aboutLabel.frame.height
    }
    
    func didVisaulSettings() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.borderWidth = 1.5
        
        realNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        didVisaulSettings()
        
        
        let s = "This is just a load of text"
        
        let height_of_text = heightForTextView(text:s)
        
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
    
    
    func spinSpinner(isActive status: Bool = true){

        if status{
            let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.gray
            loadingIndicator.startAnimating();
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
}
