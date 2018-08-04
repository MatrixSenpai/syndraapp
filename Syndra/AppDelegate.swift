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
import AppVersionMonitor
import SwiftyUserDefaults
import Fabric
import Crashlytics
import UserNotifications

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
    let window: UIWindow
    
    var currentShortcut: UIApplicationShortcutItem?
    var preferredLocation: ViewLocation?
    
    override init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        beginApplicationSetup(application, launchOptions: launchOptions)
        handleWindow()
                
        guard let sI = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem else {
            return true
        }
        
        self.currentShortcut = sI
        return false
    }
    
//    func applicationDidEnterBackground(_ application: UIApplication) {
//        let center = UNUserNotificationCenter.current()
//
//        let sName = UNNotificationSoundName("Syndra-laugh.caf")
//        let sound = UNNotificationSound(named: sName)
//
//        let content = UNMutableNotificationContent()
//        content.title = "Cool shit"
//        content.body = "A notification about me"
//        content.sound = sound
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//        let request = UNNotificationRequest(identifier: "syndraapp-localnotif", content: content, trigger: trigger)
//    }
        
    func beginApplicationSetup(_ app: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        beginParseSetup(launchOptions)
        resetCacheIfNeeded()
        
        FontBlaster.blast()
        AppVersionMonitor.sharedMonitor.startup()
        
        UIApplication.shared.shortcutItems = SyndraShortcutItems.allItems
        
        let k = UIApplication.LaunchOptionsKey.shortcutItem
        guard let shortcut = launchOptions?[k] as? UIApplicationShortcutItem else { return }
        self.application(app, performActionFor: shortcut) { (success) in
            print(success)
        }
    }
    func handleWindow() {
        switch AppVersionMonitor.sharedMonitor.state {
        case .installed:
            WindowManager.sharedInstance.move(to: .intro)
            Defaults[.dataLoaded] = false
        case .upgraded(previousVersion: _): fallthrough
        case .downgraded(previousVersion: _):
            WindowManager.sharedInstance.move(to: .loading)
            Defaults[.dataLoaded] = false
            break
        case .notChanged:
            if let p = preferredLocation { WindowManager.sharedInstance.move(to: p) }
            else { WindowManager.sharedInstance.move(to: .games) }
            GamesCommunicator.sharedInstance.checkData()
            break
        }
        
        let controller = WindowManager.sharedInstance.root
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func beginParseSetup(_ l: [UIApplication.LaunchOptionsKey: Any]? = nil) {
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

        Fabric.with([Crashlytics.self])
        PFAnalytics.trackAppOpened(launchOptions: l)
    }
    func resetCacheIfNeeded() {
        let reset = UserDefaults.standard.bool(forKey: "reset")
        UserDefaults.standard.set(false, forKey: "reset")
        if(reset) { Defaults[.dataLoaded] = false }
    }
    
    func updateRoot() {
        window.rootViewController = WindowManager.sharedInstance.root
        window.makeKeyAndVisible()
    }
}

extension AppDelegate {
    // # MARK: - App Shortcuts Handling
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("Shortcut was selected")
        completionHandler(handleShortcut(shortcutItem))
    }
    
    func handleShortcut(_ s: UIApplicationShortcutItem) -> Bool {
        switch SyndraShortcutItems.Titles.getValue(from: s) {
        case .today:
            preferredLocation = .today
            break
        }
        
        handleWindow()
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // # MARK: - Notification Handling

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        return true
    }
}
