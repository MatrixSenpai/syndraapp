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
        Parse.initialize(with: ParseClientConfiguration(block: { (config) in
            config.applicationId = "4ad2abb0-6608-4f2c-b036-b9902cf4fe35"
            config.clientKey = "spbSi2C50BsiIC16KXZPBUx6XjeszbSK"
            config.server = "https://parse.buddy.com/parse"
            config.isLocalDatastoreEnabled = true
        }))
        
        PFSeason.registerSubclass()
        PFSplit.registerSubclass()
        PFWeek.registerSubclass()
        PFDay.registerSubclass()
        PFGame.registerSubclass()
        
        FontBlaster.blast()
        AppVersionMonitor.sharedMonitor.startup()
        
        Date.setDefaultRegion(Region(tz: TimeZoneName.americaChicago, cal: CalendarName.gregorian, loc: LocaleName.englishUnitedStates))
    }
    
    func loadInterface(launchItem: LaunchItem) {
        setup(mainWindow: window)
        
        PFAnalytics.trackAppOpened(launchOptions: launchItem.launchOptions)
        
        switch AppVersionMonitor.sharedMonitor.state {
        case .installed: fallthrough
        case .upgraded(previousVersion: _): fallthrough
        case .downgraded(previousVersion: _):
            Defaults[.dataLoaded] = false
            break
        case .notChanged:
            Defaults[.dataLoaded] = false
            break
        }
        
        print(AppVersionMonitor.sharedMonitor.state)
        
        let controller = AppLoadingViewController()
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
    
    func showActual() {
        WindowManager.sharedInstance.move(to: .today)
        
        window.rootViewController = WindowManager.sharedInstance.root
    }
}
