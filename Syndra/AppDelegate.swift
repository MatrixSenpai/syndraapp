//
//  AppDelegate.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController
import FontBlaster
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: MMDrawerController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FontBlaster.blast { (names) in
            for n in names {
                print(n)
            }
        }
        
        Parse.enableLocalDatastore()
        Parse.initialize(with: ParseClientConfiguration(block: { (config) in
            config.applicationId = "4ad2abb0-6608-4f2c-b036-b9902cf4fe35"
            config.clientKey = "spbSi2C50BsiIC16KXZPBUx6XjeszbSK"
            config.server = "https://parse.buddy.com/parse"
        }))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let leftController = menuTableViewController()
        let leftNavController = UINavigationController(rootViewController: leftController)
        
        let centerController = gamesViewController()
        let centerNavController = UINavigationController(rootViewController: centerController)
        
        let rightController = gameFilterViewController()
        let rightNavController = UINavigationController(rootViewController: rightController)
        
        let viewController = MMDrawerController(center: centerNavController, leftDrawerViewController: leftNavController, rightDrawerViewController: rightNavController)
        viewController?.openDrawerGestureModeMask = .all
        viewController?.closeDrawerGestureModeMask = .all
        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
        
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
