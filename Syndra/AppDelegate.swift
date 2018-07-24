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
class AppDelegate: SuperDelegate, ApplicationLaunched {
    let window: UIWindow = UIWindow()
    
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
    }
    
    func loadInterface(launchItem: LaunchItem) {
        setup(mainWindow: window)
        
        PFAnalytics.trackAppOpened(launchOptions: launchItem.launchOptions)
        
//        switch AppVersionMonitor.sharedMonitor.state {
//        case .installed: fallthrough
//        case .upgraded(previousVersion: _): fallthrough
//        case .downgraded(previousVersion: _):
//            Defaults[.dataLoaded] = false
//            break
//        case .notChanged:
//            GamesCommunicator.sharedInstance.checkData()
//            break
//        }
        
//        let controller = WindowManager.sharedInstance.root
//        window.rootViewController = controller
//        window.makeKeyAndVisible()
        
        let c = MyTeamsViewController()
        window.rootViewController = c
        window.makeKeyAndVisible()
    }
    
    func showActual() {
        WindowManager.sharedInstance.move(to: .today)
        
        window.rootViewController = WindowManager.sharedInstance.root
    }
}
