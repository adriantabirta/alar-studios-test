//
//  AppDelegate.swift
//  alar-studios-test
//
//  Created by Tabirta Adrian on 23.08.2021.
//

import UIKit
import RxCocoa
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        LoginCoordinator().start()
        return true
    }
}

