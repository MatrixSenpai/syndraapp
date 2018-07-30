//
//  AppDelegate.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import FontBlaster
import Parse
import SuperDelegate
import SwiftDate
import AppVersionMonitor
import SwiftyUserDefaults

// Global Font Awesome declarations
let FALIGHT_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProLight", size: 20)!
let FAREGULAR_UIFONT: UIFont = UIFont(name: "FontAwesome5ProRegular", size: 20)!
let FASOLID_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProSolid", size: 20)!
let FABRANDS_UIFONT : UIFont = UIFont(name: "FontAwesome5BrandsRegular", size: 20)!

let FALIGHT_ATTR     = [NSAttributedString.Key.font: FALIGHT_UIFONT]
let FAREGULAR_ATTR   = [NSAttributedString.Key.font: FAREGULAR_UIFONT]
let FASOLID_ATTR     = [NSAttributedString.Key.font: FASOLID_UIFONT]
let FABRANDS_ATTR    = [NSAttributedString.Key.font: FABRANDS_UIFONT]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var shortcutItems: Array<UIMutableApplicationShortcutItem> {
        let todayItem: UIMutableApplicationShortcutItem = UIMutableApplicationShortcutItem(type: "syndraapp-today", localizedTitle: "Today", localizedSubtitle: "See today's games", icon: UIApplicationShortcutIcon(type: .play), userInfo: nil)
        return [todayItem]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        Parse.setLogLevel(.debug)
        print("Debug level set")
        #endif
        Parse.initialize(with: ParseClientConfiguration(block: { (config) in
            config.applicationId = "io.matrixstudios.syndraapp"
            config.clientKey = "io.matrixstudios.syndraapp-CLIENTKEY0xFF"
            config.server = "http://matrixstudios.io:1337/parse"
            config.isLocalDatastoreEnabled = true
        }))
        
        Season.registerSubclass()
        Split.registerSubclass()
        Week.registerSubclass()
        Day.registerSubclass()
        Game.registerSubclass()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func beginApplicationSetup(launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        
    }
    
}
/*
class AppDelegate: SuperDelegate, ApplicationLaunched {
    let window: UIWindow = UIWindow()
    
    var shortcutItems: Array<UIMutableApplicationShortcutItem> {
        let todayItem: UIMutableApplicationShortcutItem = UIMutableApplicationShortcutItem(type: "syndraapp-today", localizedTitle: "Today", localizedSubtitle: "See today's games", icon: UIApplicationShortcutIcon(type: .play), userInfo: nil)
        return [todayItem]
    }
    
    func setupApplication() {
        #if DEBUG
            Parse.setLogLevel(.debug)
            print("Debug level set")
        #endif
        Parse.initialize(with: ParseClientConfiguration(block: { (config) in
            config.applicationId = "io.matrixstudios.syndraapp"
            config.clientKey = "io.matrixstudios.syndraapp-CLIENTKEY0xFF"
            config.server = "http://matrixstudios.io:1337/parse"
            config.isLocalDatastoreEnabled = true
        }))
        
        Season.registerSubclass()
        Split.registerSubclass()
        Week.registerSubclass()
        Day.registerSubclass()
        Game.registerSubclass()
        
        let reset = UserDefaults.standard.bool(forKey: "reset")
        UserDefaults.standard.set(false, forKey: "reset")
        if(reset) { Defaults[.dataLoaded] = false }
        
        FontBlaster.blast()
        AppVersionMonitor.sharedMonitor.startup()
        
        UIApplication.shared.shortcutItems = shortcutItems
    }
    
    func loadInterface(launchItem: LaunchItem) {
        setup(mainWindow: window)
        
        PFAnalytics.trackAppOpened(launchOptions: launchItem.launchOptions)
        
        switch AppVersionMonitor.sharedMonitor.state {
        case .installed: fallthrough
        case .upgraded(previousVersion: _): fallthrough
        case .downgraded(previousVersion: _):
            Defaults[.dataLoaded] = false
            WindowManager.sharedInstance.move(to: .intro)
            break
        case .notChanged:
            GamesCommunicator.sharedInstance.checkData()
            WindowManager.sharedInstance.move(to: .intro)
            break
        }
        
        let controller = WindowManager.sharedInstance.root
        window.rootViewController = controller
        window.makeKeyAndVisible()
        
    }
}

extension AppDelegate: ShortcutCapable {
    func canHandle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        if shortcutItem.type == "syndraapp-today" { return true }
        
        return false
    }
    
    func handle(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    
}

extension AppDelegate: RemoteNotificationCapable {
    func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
        
    }
    
    func didFailToRegisterForRemoteNotifications(withError error: Error) {
        
    }
    
    func didReceive(remoteNotification: RemoteNotification, origin: UserNotificationOrigin, fetchCompletionHandler completionHandler: @escaping ((UIBackgroundFetchResult) -> Void)) {
        
    }
    
    
}

extension AppDelegate: LocalNotificationCapable {
    func didReceive(localNotification: UILocalNotification, origin: UserNotificationOrigin) {
        
    }
    
    func requestedUserNotificationSettings() -> UIUserNotificationSettings {
        return UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
    }
    
    func didReceive(userNotificationPermissions: UserNotificationPermissionsGranted) {
        
    }
    
    
}
*/
