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
    
    override init() {
        window = UIWindow(frame: UIScreen.main.bounds)
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        beginApplicationSetup(launchOptions: launchOptions)
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
        
    func beginApplicationSetup(launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
        beginParseSetup(launchOptions)
        resetCacheIfNeeded()
        
        FontBlaster.blast()
        AppVersionMonitor.sharedMonitor.startup()
        
        UIApplication.shared.shortcutItems = SyndraShortcutItems.allItems
    }
    func handleWindow() {
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
    
    // # MARK: - App Shortcuts Handling
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        print("Shortcut was selected")
        completionHandler(handleShortcut(shortcutItem))
    }
    
    func handleShortcut(_ s: UIApplicationShortcutItem) -> Bool {
        switch SyndraShortcutItems.Titles.getValue(from: s) {
        case .today:
            break
        default: return false
        }
        
        return true
    }
    
    // # MARK: - Notification Handling
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
