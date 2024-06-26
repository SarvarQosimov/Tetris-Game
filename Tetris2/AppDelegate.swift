//
//  AppDelegate.swift
//  Tetris2
//
//  Created by Sarvar Qosimov on 26/04/24.
//

import Foundation

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        let navController = UINavigationController(rootViewController: HomeVC())
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}
