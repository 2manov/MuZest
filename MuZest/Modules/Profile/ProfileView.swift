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
        
        let ref = Database.database().reference()
        
        if Auth.auth().currentUser != nil {
            ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if snapshot.value != nil {
                    let dict = snapshot.value as! Dictionary<String,Any>
                    print(dict.keys)
                    print(type(of: Array(dict.keys)))
                    }
                
            })
        }
//        performSegue(withIdentifier: "toSettings", sender: Any.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        if segue.identifier == "toSettings" {
            let destinationVC = segue.destination as! SettingsView // Не лучше ли протокол?
            destinationVC.realName = realNameLabel.text ?? ""
            destinationVC.about = aboutLabel.text ?? ""
            destinationVC.photo = profileImage.image
            }
    }
    
    func setDataToPhoto(with data: Data){
        profileImage.image = UIImage(data: data)
    }
    
    
    func heightForTextView(text:String){
        self.aboutLabel.numberOfLines = 0
        self.aboutLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.aboutLabel.font = UIFont(name: "Helvetica", size: 16.0)
        self.aboutLabel.text = text
        self.aboutLabel.sizeToFit()
        
        DispatchQueue.main.async {
            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
            let heightConstraint = NSLayoutConstraint(item: self.scrollView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.realScrollView.frame.size.height + self.aboutLabel.frame.height + 250)
            
            self.view.addConstraints([heightConstraint])
            self.scrollView.addConstraints([heightConstraint])
        }
    }
    
    func didVisaulSettings() {
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.lightGray.cgColor
        profileImage.layer.borderWidth = 2
        
        realNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        didVisaulSettings()
        
}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter.configureView()
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
            loadingIndicator.startAnimating()
            
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
        
    }
}
