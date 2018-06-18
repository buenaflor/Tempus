//
//  AppDelegate.swift
//  Tempus
//
//  Created by Giancarlo on 23.05.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?

    lazy var loginVC: LoginViewController = {
        let vc = LoginViewController()
        return vc
    }()
    
    lazy var homeVC: HomeViewController = {
        let vc = HomeViewController()
        return vc
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
//        try! Auth.auth().signOut()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = homeVC.wrapped()
        
        if let currentUser = Auth.auth().currentUser {
            // Load Data
        }
        else {
            homeVC.present(loginVC.wrapped(), animated: true, completion: nil)
        }
        
        setupUI()
        
        return true
    }
    
    private func setupUI() {
        UINavigationBar.appearance().barTintColor = UIColor.Temp.main
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Terminate session with room
    }

}

