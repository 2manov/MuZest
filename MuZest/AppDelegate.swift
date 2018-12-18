//
//  AppDelegate.swift
//  MuZest
//
//  Created by Никита Туманов on 18/10/2018.
//  Copyright © 2018 Никита Туманов. All rights reserved.
//

import UIKit
import Firebase
import XCGLogger



let log: XCGLogger = {
    let log = XCGLogger.default
    
    #if DEBUG
    log.setup(level: .verbose, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
    #else
    log.setup(level: .severe, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true)
    #endif
    
    let emojiLogFormatter = PrePostFixLogFormatter()
    emojiLogFormatter.apply(prefix: "🗯 ", postfix: "", to: .verbose)
    emojiLogFormatter.apply(prefix: "🔹 ", postfix: "", to: .debug)
    emojiLogFormatter.apply(prefix: "ℹ️ ", postfix: "", to: .info)
    emojiLogFormatter.apply(prefix: "⚠️ ", postfix: "", to: .warning)
    emojiLogFormatter.apply(prefix: "‼️ ", postfix: "", to: .error)
    emojiLogFormatter.apply(prefix: "💣 ", postfix: "", to: .severe)
    log.formatters = [emojiLogFormatter]
    
    return log
}()

class MyProfile {
    
    private let ref = Database.database().reference()
    
    var username: String?
    var real_name: String?
    var about: String?
    var follow_names: Array<Substring>?
    var photo: Data?
    var follower_names: Array<Substring>?
    var post_ids: Array<Substring>?
    
    var loadPhotoStatus : Bool?
    
    static let shared = MyProfile()
    
    private init() {
        updateData()
    }
    
    func updateData(){
        if Auth.auth().currentUser != nil {
            ref.child("users").queryOrdered(byChild: "user_id").queryEqual(toValue: Auth.auth().currentUser?.uid).observeSingleEvent(of: .childAdded, with: { snapshot in
                if snapshot.value != nil {
                    let dict = snapshot.value as! Dictionary<String,String>
                    if dict["profile_photo_url"] != ""  {
                        let gsReference = Storage.storage().reference(forURL: dict["profile_photo_url"]!)
                        gsReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                DispatchQueue.main.async {
                                    self.photo = data!
                                    self.loadPhotoStatus = true
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.username =  snapshot.key
                        self.real_name = dict["real_name"]
                        self.about =  dict["about"]
                        self.follow_names = dict["follows"]?.split(separator: "\t")
                        self.follower_names = "followers".split(separator: "\t")
                        self.post_ids =  "post".split(separator :"\t")
                    }
                    
                }
                else {
                    print ("profile can't fill")
                }
            })
        }
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
     
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if Auth.auth().currentUser == nil
        {
            let authController = storyboard.instantiateViewController(withIdentifier: "AuthController")
            self.window?.rootViewController = authController
        }
        else
        {
            let feedController = storyboard.instantiateViewController(withIdentifier: "FeedController")
            self.window?.rootViewController = feedController
        }
        
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        MyProfile.shared.loadPhotoStatus = false
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
}
