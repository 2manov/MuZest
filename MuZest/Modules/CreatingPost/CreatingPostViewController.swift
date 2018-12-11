//
//  CreatingPostViewController.swift
//  MuZest
//
//  Created by Ivan Vozvakhov on 09/12/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices
import iTunesSearchAPI

class CreatingPostViewController: UIViewController
{
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var captionTextVire: UITextView!
    @IBOutlet weak var postButton: UIButton!
    
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.clickFunction))
        photo.addGestureRecognizer(tapGesture)
        photo.isUserInteractionEnabled = true
        
    }
    
    @objc func clickFunction(){
        
        let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func postButton_touch_up_inside(_ sender: UIButton) {
        print("Waiting...")
        
        if let profileImg = self.selectedImage, let imageData = profileImg.jpegData(compressionQuality: 0.1){
            let photoIdString = NSUUID().uuidString
            
            // forURL: "gs://muzest-94c76.appspot.com"
            let storageRef = Storage.storage().reference().child("posts").child(photoIdString)
            
            print(storageRef)
            
            storageRef.putData(imageData, metadata : nil) {
                (metadata, error) in
                
                if (error != nil) {
                    print (error as Any)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard url != nil else {
                        return
                    }
                    self.sendDataToDatabase(photoUrl: (url?.absoluteString)!)
                }
            }
        } else {
            print("File cannot be empty")
        }
    }
    
    func sendDataToDatabase(photoUrl : String){
        let ref = Database.database().reference()
        let postsReference = ref.child("posts")
        let newPostId = postsReference.childByAutoId().key
        let newPostReference = postsReference.child(newPostId!)
        newPostReference.setValue(["photoUrl": photoUrl], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            print("Success")
        })
    }
}
extension CreatingPostViewController: UIDocumentMenuDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let myURL = url as URL
        print("import result : \(myURL)")
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
